class CreateHashtagsAndHashtagQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :hashtags do |t|
      t.string :text, index: {unique: true}

      t.timestamps
    end

    create_table :hashtag_questions do |t|
      t.belongs_to :hashtag
      t.belongs_to :question

      t.timestamps
    end
  end
end
