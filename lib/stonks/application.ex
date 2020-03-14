defmodule Stonks.Application do
  use Application

  def start(_type, _args) do
    oban_config = Application.get_env(:stonks, Oban)

    children = [
      Stonks.Repo,
      {Oban, oban_config},
      StonksWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Stonks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    StonksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
