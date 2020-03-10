use Mix.Config

config :stonks,
  ecto_repos: [Stonks.Repo],
  generators: [binary_id: true]

config :stonks, StonksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jD6ebpK1azZ1+k4lYM38zPfdFPPWYBkaLFG5piCHh5HgEIfnTPaX5SPD4h6wOyRZ",
  render_errors: [view: StonksWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Stonks.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :stonks, Stonks.Accounts.Guardian,
  issuer: "stonks",
  secret_key: "dYrNfpiOzVYrEuMEO6656zFwmzvOk2aEFgcR9+OpbAkhsH02w2clUnjALO2YlZI2"

import_config "#{Mix.env()}.exs"
