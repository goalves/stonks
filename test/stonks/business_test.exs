defmodule Stonks.BusinessTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Stonks.Accounts.User
  alias Stonks.Business
  alias Stonks.Business.Transaction

  @max_integer 999_999_999

  describe "create_transaction/1" do
    test "returns a created withdraw transaction" do
      balance = :rand.uniform(@max_integer)
      user = insert(:user, balance: balance)

      attributes = params_for(:withdraw_transaction, origin_user: nil, origin_user_id: user.id, amount: balance)

      assert {:ok, transaction = %Transaction{}} = Business.create_transaction(attributes)
      assert transaction.origin_user_id == user.id
      assert transaction.amount == balance
      assert transaction.type == "withdraw"
      assert is_nil(transaction.destination_user_id)
      refute Transaction |> Repo.get(transaction.id) |> is_nil()
      assert User |> Repo.get(user.id) |> Map.get(:balance) == 0
    end

    test "returns a created transfer transaction" do
      balance = :rand.uniform(@max_integer)
      user = insert(:user, balance: balance)
      destination_user = insert(:user, balance: 0)

      attributes =
        params_for(:transfer_transaction,
          origin_user: nil,
          origin_user_id: user.id,
          amount: balance,
          destination_user: nil,
          destination_user_id: destination_user.id
        )

      assert {:ok, transaction = %Transaction{}} = Business.create_transaction(attributes)
      assert transaction.origin_user_id == user.id
      assert transaction.destination_user_id == destination_user.id
      assert transaction.amount == balance
      assert transaction.type == "transfer"
      refute Transaction |> Repo.get(transaction.id) |> is_nil()
      assert User |> Repo.get(user.id) |> Map.get(:balance) == 0
      assert User |> Repo.get(destination_user.id) |> Map.get(:balance) == balance
    end

    test "returns an error when transaction attributes are invalid",
      do: assert({:error, %Ecto.Changeset{}} = Business.create_transaction(%{}))
  end
end
