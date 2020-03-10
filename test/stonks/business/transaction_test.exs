defmodule Stonks.Business.TransactionTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.{Changeset, UUID}
  alias Stonks.Business.Transaction

  describe "changeset/2" do
    test "returns a valid changeset when parameters are valid for a withdraw" do
      attributes = params_for(:withdraw_transaction)
      assert %Changeset{valid?: true} = Transaction.changeset(%Transaction{}, attributes)
    end

    test "returns a valid changeset when parameters are valid for a transfer" do
      attributes = params_for(:transfer_transaction)
      assert %Changeset{valid?: true} = Transaction.changeset(%Transaction{}, attributes)
    end

    test "returns an invalid changeset when a withdraw has a destination user" do
      user_id = UUID.generate()
      attributes = :withdraw_transaction |> params_for() |> Map.put(:destination_user_id, user_id)
      changeset = Transaction.changeset(%Transaction{}, attributes)
      refute changeset.valid?
      assert errors_on(changeset) == %{destination_user: ["cannot be set on withdraws"]}
    end

    test "returns an invalid changeset when a transfer does not have a destination user" do
      attributes = :transfer_transaction |> params_for() |> Map.put(:destination_user_id, nil)
      changeset = Transaction.changeset(%Transaction{}, attributes)
      refute changeset.valid?
      assert errors_on(changeset) == %{destination_user: ["needs to be set on transfers"]}
    end

    test "returns an invalid changeset when a transfer has the same origin and destination" do
      user_id = UUID.generate()
      same_origin_and_destination_map = %{origin_user_id: user_id, destination_user_id: user_id}
      attributes = :transfer_transaction |> params_for() |> Map.merge(same_origin_and_destination_map)

      changeset = Transaction.changeset(%Transaction{}, attributes)
      refute changeset.valid?
      assert errors_on(changeset) == %{destination_user: ["cannot be the same as the origin account"]}
    end

    test "returns an invalid changeset when parameters are missing" do
      invalid_attributes = %{}
      changeset = Transaction.changeset(%Transaction{}, invalid_attributes)
      refute changeset.valid?

      assert errors_on(changeset) == %{
               amount: ["can't be blank"],
               origin_user_id: ["can't be blank"],
               type: ["can't be blank"]
             }
    end
  end
end
