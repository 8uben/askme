class Question < ApplicationRecord
  # Эта команда добавляет связь с моделью User на уровне объектов, она же
  # добавляет метод .user к данному объекту.
  #
  # Когда мы вызываем метод user у экземпляра класса Question, рельсы
  # поймут это как просьбу найти в базе объект класса User со значением id,
  # который равен question.user_id.
  belongs_to :user
  # рельсы добавят к нему `_id` и найдут нужное поле в таблице
  belongs_to :author, class_name: 'User', optional: true

  has_many :hashtag_questions, dependent: :destroy
  has_many :hashtags, through: :hashtag_questions

  # валидируем сразу и связь, теперь нельзя создать вопрос, у которого нет юзера
  validates :text, presence: true
  validates :text, length: {maximum: 255}

  after_save_commit :set_hashtags

  private

  def parse_hashtags(string)
    string.scan(Hashtag::HASHTAG_REGEX).map(&:downcase)
  end

  def set_hashtags
    self.hashtags =
      parse_hashtags("#{text} #{answer}").uniq.map do |hashtag|
        Hashtag.create_or_find_by(text: hashtag)
      end
  end
end
