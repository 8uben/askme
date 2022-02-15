class HashtagsController < ApplicationController
  def show
    hashtag = Hashtag.with_questions.find_by!(text: "##{params[:hashtag]}")
    @questions = hashtag.questions.includes(:author, :user).sorted
  end
end
