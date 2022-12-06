class QuestionsController < ApplicationController
  before_action :set_question

  # GET /questions/1/edit
  def edit
  end

  def create
    @question.author = current_user

    # Проверяем капчу вместе с сохранением вопроса. Если в капче ошибка,
    # она будет добавлена в массив @question.errors.
    if check_captcha(@question) && @question.save
      redirect_to user_path(@question.user), notice: 'Вопрос задан'
    else
      render :edit
    end
  end

  def update
    if @question.update(question_params)
      redirect_to user_path(@question.user), notice: 'Вопрос сохранен'
    else
      render :edit
    end
  end

  def destroy
    # Перед тем, как удалять вопрос, сохраним пользователя, чтобы знать, куда
    # редиректить после удаления
    user = @question.user
    @question.destroy
    redirect_to user_path(user), notice: 'Вопрос удален :('
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find_by(id: params[:id]) || Question.new(question_params)
  end

  def question_params
    # Защита от уязвимости: если текущий пользователь — адресат вопроса,
    # он может менять ответы на вопрос, ему доступно и поле :answer.
    if current_user.present? &&
       params[:question][:user_id].to_i == current_user.id

      params.require(:question).permit(:user_id, :text, :answer)
    else
      params.require(:question).permit(:user_id, :text)
    end
  end

  def authorize_user
    reject_user unless @user == current_user
  end

  def check_captcha(model)
    current_user.present? || verify_recaptcha(model: model)
  end
end
