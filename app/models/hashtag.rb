class Hashtag < ApplicationRecord
  HASHTAG_REGEX = /#[[:word:]-]+/

  has_many :hashtag_questions, dependent: :destroy
  has_many :questions, through: :hashtag_questions

  validates :text, presence: true, format: {with: HASHTAG_REGEX}

  scope :with_questions, -> { joins(:hashtag_questions).distinct }

  before_validation :convert_downcase

  private

  def convert_downcase
    text&.downcase!
  end
end
