# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
  # frozen_string_literal: true

    # facebook経由のログインの場合は、アカウント選択後、facebookメソッドにレスポンスが来ます。
    def facebook
      authorization
    end

    # google経由のログインの場合は、アカウント選択後、googleメソッドにレスポンスが来ます。
    def google_oauth2
      authorization
    end

    private
    def authorization
      auth = request.env["omniauth.auth"]
      sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_initialize
      @user = User.from_sns_credential(sns, auth)
  
      if @user.persisted?
        # @userがDBにいるならば: ログインしてトップページへ飛ばす
        sign_in_and_redirect @user, event: :authentication
      else
        # @userがDBにいないならば: ユーザ新規ログイン画面に遷移させる。
        # sns経由であることをウィザード形式の最後まで保持しておくためにsessionに保存する。
        session["devise.regist_data"] ||= {}
        session["devise.regist_data"]["sns"] = sns.attributes
        render template: 'users/registrations/new'
      end
    end
end
