use Mix.Config

config :stonks, Stonks.Repo,
  username: "postgres",
  password: "postgres",
  database: "stonks_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :stonks, StonksWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
