defmodule Stonks.Repo do
  use Ecto.Repo,
    otp_app: :stonks,
    adapter: Ecto.Adapters.Postgres
end
