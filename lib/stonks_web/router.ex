defmodule StonksWeb.Router do
  use StonksWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StonksWeb do
    pipe_through :api
  end
end
