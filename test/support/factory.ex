defmodule Stonks.Factory do
  use ExMachina.Ecto, repo: Stonks.Repo

  alias Ecto.UUID
  alias Faker.Internet
  alias Stonks.Accounts.User

  @max_integer 999_999_999

  def user_factory,
    do: %User{
      username: Internet.user_name(),
      id: UUID.generate(),
      balance: :rand.uniform(@max_integer),
      password_hash: UUID.generate(),
      password: UUID.generate()
    }
end
