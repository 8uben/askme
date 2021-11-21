class Question < ApplicationRecord
  # Эта команда добавляет связь с моделью User на уровне объектов, она же
  # добавляет метод .user к данному объекту.
  #
  # Когда мы вызываем метод user у экземпляра класса Question, рельсы
  # поймут это как просьбу найти в базе объект класса User со значением id,
  # который равен question.user_id.
  belongs_to :user

  # валидируем сразу и связь, теперь нельзя создать вопрос, у которого нет юзера
  validates :user, :text, presence: true
  validates :text, length: {maximum: 255}
end
