defmodule Stonks.Factory do
  use ExMachina.Ecto, repo: Stonks.Repo

  alias Ecto.UUID
  alias Faker.{Internet, Name}
  alias Stonks.Accounts.{Operator, User}
  alias Stonks.Business.Transaction

  @max_integer 999_999_999

  def user_factory do
    %User{
      id: UUID.generate(),
      balance: :rand.uniform(@max_integer),
      password_hash: UUID.generate(),
      password: UUID.generate(),
      name: Name.name(),
      email: Internet.email()
    }
  end

  def withdraw_transaction_factory do
    origin_user = build(:user, balance: 10_000)

    %Transaction{
      type: "withdraw",
      origin_user: origin_user,
      origin_user_id: origin_user.id,
      destination_user: nil,
      destination_user_id: nil,
      amount: 500
    }
  end

  def transfer_transaction_factory do
    origin_user = build(:user, balance: 10_000)
    destination_user = build(:user, balance: 0)

    %Transaction{
      type: "transfer",
      origin_user: origin_user,
      origin_user_id: origin_user.id,
      destination_user: destination_user,
      destination_user_id: destination_user.id,
      amount: 500
    }
  end

  def operator_factory do
    %Operator{
      password_hash: UUID.generate(),
      password: UUID.generate(),
      email: Internet.email()
    }
  end
end
