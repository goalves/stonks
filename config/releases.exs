import Config

config :stonks, Stonks.Endpoint, server: true

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :stonks, Stonks.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

config :stonks, Stonks.Repo,
  username: System.fetch_env!("DATABASE_USERNAME"),
  password: System.fetch_env!("DATABASE_PASSWORD"),
  database: System.fetch_env!("DATABASE_NAME"),
  ssl: true,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :stonks, Stonks.Guardian,
  issuer: "stonks",
  secret_key: Sytem.fetch_env!("GUARDIAN_SECRET_KEY")

config :stonks, Stonks.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: Sytem.fetch_env!("SENDGRID_API_KEY")
