class Users::RegistrationsController < Devise::RegistrationsController

# frozen_string_literal: true
before_action :session_has_not_user_data, only: [:new_address_preset, :create_address_preset]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def create
    # 追加ここから
        if session["devise.regist_data"] && session["devise.regist_data"]["sns"]
          password = Devise.friendly_token[8,12] + "1a"
          params[:user][:password] = password
          params[:user][:password_confirmation] = password
        end
    # 追加ここまで
    
        @user = User.new(sign_up_params)
        ## @userがバリデーションに引っかかるなら入力させなおす
        unless @user.valid?
          render :new and return
        end
        ## @userがバリデーションをパスするならsessionに入れておく
        ## attributesメソッドは、@userの属性値をハッシュで取得するメソッド
    
    # 追加ここから
        session["devise.regist_data"] ||= {}
        session["devise.regist_data"][:user] = @user.attributes
    # 追加ここまで
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
# 追加
    @sns = SnsCredential.new(session["devise.regist_data"]["sns"])

    ## @userに@address_presetを紐づける
    @user.build_address_preset(@address_preset.attributes)
# 追加
    @user.sns_credentials.new(@sns.attributes)

    ## @userがバリデーションに引っかかるなら入力させなおす
    unless @user.valid?
      render :new_address_preset and return
    end
    @user.save
    session["devise.regist_data"]["user"].clear
# 追加
    session["devise.regist_data"]["sns"]&.clear

    ## ログイン状態にする
    sign_in(:user, @user)
  end

  private

  def address_preset_params
    params.require(:address_preset).permit(:postal_code, :prefecture, :city, :addresses, :building, :phone_number)
  end

  ## URL直打ちではusers/registrations#new_address_preset等にアクセスできないようにする
  def session_has_not_user_data
    redirect_to root_path, alert: "ユーザー情報がありません" unless session["devise.regist_data"]
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
