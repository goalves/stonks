defmodule Stonks.Accounts.OperatorTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.{Changeset, UUID}
  alias Stonks.Accounts.Operator

  describe "changeset/2" do
    test "returns a valid changeset when parameters are valid" do
      attributes = params_for(:operator)
      assert %Changeset{valid?: true} = Operator.changeset(%Operator{password_hash: UUID.generate()}, attributes)
    end

    test "returns an invalid changeset when parameters are invalid" do
      invalid_attributes = %{}
      changeset = Operator.changeset(%Operator{}, invalid_attributes)

      refute changeset.valid?
      assert errors_on(changeset) == %{password_hash: ["can't be blank"], email: ["can't be blank"]}
    end
  end
end
