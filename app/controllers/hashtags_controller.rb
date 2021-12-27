class HashtagsController < ApplicationController
  def show
    @questions =
      Hashtag.joins(:hashtag_questions).distinct.find_by!(text: "##{params[:hashtag]}")
        .questions.order(updated_at: :desc)
  end
end
