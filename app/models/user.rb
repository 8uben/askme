class User < ApplicationRecord
  require 'openssl'

  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  USERNAME_REGEX = /\A\w+\z/
  USERNAME_MAX_LENGTH = 40
  HEX_BACKGROUND_COLOR_REGEX = /\A#([\da-f]{3}){1,2}\z/
  DEFAULT_BACKGROUND_COLOR = '#005a55'

  # Когда мы вызываем метод questions у экземпляра класса User, рельсы
  # поймут это как просьбу найти в базе все объекты класса Questions со
  # значением user_id равный user.id.
  has_many :questions, dependent: :destroy
  has_many :asked_questions, class_name: 'Question', foreign_key: :author_id, dependent: :nullify

  # Виртуальное поле, которое не сохраняется в базу. Из него перед сохранением читается пароль,
  # и сохраняется в базу уже зашифрованная версия пароля в
  attr_accessor :password

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true

  # валидация будет проходить только при создании нового юзера
  validates :password, presence: true, on: :create

  # и поле подтверждения пароля
  validates_confirmation_of :password

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :username, length: {maximum: USERNAME_MAX_LENGTH}, format: {with: USERNAME_REGEX}
  validates :background_color, format: {with: HEX_BACKGROUND_COLOR_REGEX}, on: :update

  before_validation :convert_to_downcase_username_and_email
  before_save :encrypt_password

  # Служебный метод, преобразующий бинарную строку в шестнадцатиричный формат,
  # для удобства хранения.
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  # Основной метод для аутентификации юзера (логина). Проверяет email и пароль,
  # если пользователь с такой комбинацией есть в базе, возвращает этого
  # пользователя. Если нет — возвращает nil.
  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    user = find_by(email: email)

    # Если пользователь не найден, возвращает nil
    return nil unless user.present?

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password

    # Иначе, возвращаем nil
    nil
  end

  def bg_color
    background_color || DEFAULT_BACKGROUND_COLOR
  end

  private

  def encrypt_password
    if password.present?
      # Создаем т.н. «соль» — случайная строка, усложняющая задачу хакерам по
      # взлому пароля, даже если у них окажется наша БД.
      # У каждого юзера своя «соль», это значит, что если подобрать перебором пароль
      # одного юзера, нельзя разгадать, по какому принципу
      # зашифрованы пароли остальных пользователей
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # Создаем хэш пароля — длинная уникальная строка, из которой невозможно
      # восстановить исходный пароль. Однако, если правильный пароль у нас есть,
      # мы легко можем получить такую же строку и сравнить её с той, что в базе.
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )

      # Оба поля попадут в базу при сохранении (save).
    end
  end

  def convert_to_downcase_username_and_email
    username&.downcase!
    email&.downcase!
  end
end
