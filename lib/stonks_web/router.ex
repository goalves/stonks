defmodule StonksWeb.Router do
  use StonksWeb, :router

  @version "v1"

  pipeline :api, do: plug(:accepts, ["json"])

  scope "/api/#{@version}", StonksWeb do
    pipe_through :api
  end
end
