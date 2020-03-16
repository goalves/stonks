use Mix.Config

config :stonks, StonksWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "stonks.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

config :logger, level: :info
