defmodule StonksWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :stonks

  plug Plug.Static,
    at: "/",
    from: :stonks,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_stonks_key",
    signing_salt: "5ygNJkuO"

  plug StonksWeb.Router
end
