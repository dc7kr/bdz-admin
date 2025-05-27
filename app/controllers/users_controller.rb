class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    authorize! :index, @user, message: "Not authorized as an administrator."
    @users = User.order("#{sort_column} #{sort_direction}").page(params[:page]).per(10)

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def for_admin_notify
    authorize! :index, @user, message: "Not authorized as an administrator."
    @users = User.for_admin_notify

    respond_to do |format|
      format.js
      format.html
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    filter_params = user_params

    if filter_params[:password].blank?
      logger.info("Removing blank password key")
      filter_params.delete :password
    end

    respond_to do |format|
      if @user.update(filter_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "email"
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :name)
  end
end
