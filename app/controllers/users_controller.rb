class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.order(created_at: :desc)

    @amount_answered_questions = @user.questions.where.not(answer: nil).count
    @amount_unanswered_questions = @questions.size - @amount_answered_questions

    # Для формы нового вопроса создаём заготовку, вызывая build у результата вызова метода @user.questions.
    @new_question = @user.questions.build
  end
end
