defmodule StonksWeb.Router do
  use StonksWeb, :router

  alias StonksWeb.Guardian.{OperatorAuthPipeline, UserAuthPipeline}

  @version "v1"

  pipeline :api, do: plug(:accepts, ["json"])

  pipeline :user_auth, do: plug(UserAuthPipeline)
  pipeline :operator_auth, do: plug(OperatorAuthPipeline)

  scope "/api/#{@version}", StonksWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/auth", AuthController, :sign_in

    scope "/users/me" do
      pipe_through :user_auth

      get "/", UserController, :show_me
      post "/transactions", TransactionController, :create, as: :users_me_transactions
    end
  end
end
