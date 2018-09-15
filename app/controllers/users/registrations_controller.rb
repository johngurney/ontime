# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  @@alter=""
    # before_action :configure_sign_up_params, only: [:create]
``  # before_action :configure_account_update_params, only: [:update]
  skip_before_action :require_no_authentication
  before_action :find_user_from_confirmation_token, only: [:email_confirm]
  #before_action :find_user_from_user_id, only: [:email_confirm]


  # GET /resource/sign_up
   def new
     puts "Got Here"
     Devise.token_generator.digest(User, :confirmation_token, 'abc')
     render 'homepage/test'

     super
   end

  # POST /resource
   def create
     existing_users_with_same_email=User.where(email: params[:user][:email])
     if existing_users_with_same_email.count>0
       $alert="A user with that email already exists, deleting that user."
        existing_users_with_same_email.delete_all
     end
     super

   end

  def email_confirm
    puts "URL:" + request.url.to_s
    puts "users id:" + params[:userid].to_s
    if @user
      current_time=DateTime.now
      confirmation_due_time = @user.confirmation_sent_at + Devise.allow_unconfirmed_access_for
      puts "ID=" + @user.id.to_s
      #puts "Current time: " + current_time.strftime("%d %b %T") + "Confirmation time: " + confirmation_due_time.strftime("%d %b %T")
      if current_time > confirmation_due_time
        @user.delete
        render 'confirmations/error_out_of_time'
      end
    else
      render 'confirmations/error'
    end
  end

  def email_sign_in
    puts "URL:" + request.url.to_s
    puts "users id:" + params[:userid].to_s
    user= User.find(params[:userid])
    puts "Updating users" + user.email
    user.update(update_params)
    user.save
    redirect_to root_path
  end


  def find_user_from_confirmation_token
    @user = User.where(confirmation_token: params[:confirmation_token]).last
  end

  def find_user_from_user_id
    @user = User.where(confirmation_token: params[:confirmation_token]).last
  end


  private

  def sign_up_params
    params.require(:user).permit(:user_status, :first_name, :last_name, :email)
  end

  def update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end


  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
