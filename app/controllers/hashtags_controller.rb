class HashtagsController < ApplicationController
  def show
    @questions =
      Hashtag.with_questions.find_by!(text: "##{params[:hashtag]}").questions.sorted
  end
end
