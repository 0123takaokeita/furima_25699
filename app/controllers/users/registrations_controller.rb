# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    ## @userがバリデーションに引っかかるなら入力させなおす
    unless @user.valid?
      render :new and return
    end
    ## @userがバリデーションをパスするならsessionに入れてお
    ## attributesメソッドは、@userの属性値をハッシュで取得するメソッド
    session["devise.regist_data"] = {user: @user.attributes}
    ## passwordは@user.attributesに含まれないのでparamsから別途取得する
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    ## newaddress_presetのビューで使用する@addressを定義（@userに紐づけておく）
    @address_preset = @user.build_address_preset
    ## newaddress_presetのビューを表示させる
    render :new_address_preset
  end


  def create_address_preset
    ## sessionに入っているuserの情報を元に@userを定義しなおす
    @user = User.new(session["devise.regist_data"]["user"])
    @address_preset = AddressPreset.new(address_preset_params)
    ## @userに@address_presetを紐づける
    @user.build_address_preset(@address_preset.attributes)
    ## @userがバリデーションに引っかかるなら入力させなおす
    unless @user.valid?
      render :new_address_preset and return
    end
    @user.save
    session["devise.regist_data"]["user"].clear
    ## ログイン状態にする
    sign_in(:user, @user)
  end

  private

  def address_preset_params
    params.require(:address_preset).permit(:postal_code, :prefecture, :city, :addresses, :building, :phone_number)
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
