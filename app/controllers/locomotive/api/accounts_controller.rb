module Locomotive
  module Api
    class AccountsController < Api::BaseController

      before_filter :load_account, only: [:show, :update, :destroy]
      before_filter :load_accounts, only: [:index]

      skip_before_filter :require_account, only: [:create]
      skip_before_filter :require_site
      skip_before_filter :validate_site_membership

      def index
        authorize Locomotive::Account
        @accounts = @accounts.ordered
        respond_with @accounts
      end

      def show
        authorize @account
        respond_with @account
      end

      def create
        @account = Account.new
        @account.from_presenter(account_params_on_create).save
        respond_with @account, location: -> { main_app.locomotive_api_account_url(@account) }
      end

      def update
        authorize @account
        @account.from_presenter(params[:account]).save
        respond_with @account, location: main_app.locomotive_api_account_url(@account)
      end

      def destroy
        authorize @account
        @account.destroy
        respond_with @account
      end

      private

      def load_account
        @account = Locomotive::Account.find(params[:id])
      end

      def load_accounts
        @accounts = Locomotive::Account.all
      end

      def current_membership
        Locomotive::Membership.new(account: current_locomotive_account)
      end

      def account_params_on_create
        params.require(:account).permit(:name, :email, :password, :password_confirmation)
      end

    end

  end
end
