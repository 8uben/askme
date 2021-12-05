class UsersController < ApplicationController
  before_action :load_user, except: [:index, :create, :new]

  # Проверяем, имеет ли юзер доступ к экшену, делаем это для всех действий, кроме
  # :index, :new, :create, :show — к ним есть доступ у всех, даже у анонимных юзеров.
  before_action :authorize_user, except: [:index, :new, :create, :show]

  def index
    @users = User.all
  end

  def new
    # Если юзер залогинен, отправляем его на главную с сообщением
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?

    # Иначе, создаем болванку нового пользователя.
    @user = User.new
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

  def create
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Пользователь успешно зарегистрирован!'
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Данные обновлены'
    else
      render 'edit'
    end
  end

  private

  def user_params
    # берём объект params, потребуем у него иметь ключ
    # :user, у него с помощью метода permit разрешаем
    # набор инпутов. Ничего лишнего, кроме них, в пользователя не попадёт
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :username, :avatar_url, :background_color
    )
  end

  def load_user
    # защищаем от повторной инициализации с помощью ||=
    @user ||= User.find(params[:id])
  end

  def authorize_user
    reject_user unless @user == current_user
  end
end
