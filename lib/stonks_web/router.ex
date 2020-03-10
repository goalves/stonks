defmodule StonksWeb.Router do
  use StonksWeb, :router

  alias StonksWeb.Guardian.AuthPipeline

  @version "v1"

  pipeline :api, do: plug(:accepts, ["json"])

  pipeline :api_auth, do: plug(AuthPipeline)

  scope "/api/#{@version}", StonksWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/auth", AuthController, :sign_in
  end

  scope "/api/#{@version}", StonksWeb do
    pipe_through [:api, :api_auth]

    get "/users/me", UserController, :show_me
  end
end
