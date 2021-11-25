class QuestionsController < ApplicationController
  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to user_path(@question.user), notice: 'Вопрос задан'
    else
      render :edit
    end
  end

  private

  def question_params
    params.require(:question).permit(:user_id, :text)
  end
end
