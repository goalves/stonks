defmodule Stonks.Accounts.UserTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.{Changeset, UUID}
  alias Stonks.Accounts.User

  describe "create_changeset/1" do
    test "returns a valid changeset when parameters are valid" do
      attributes = params_for(:user)
      assert %Changeset{valid?: true} = User.create_changeset(attributes)
    end

    test "returns a valid changeset with a password_hash when password is provided" do
      attributes = params_for(:user)
      assert %Changeset{valid?: true, changes: changes} = User.create_changeset(attributes)
      refute is_nil(changes.password_hash)
    end

    test "returns an invalid changeset when parameters are invalid" do
      invalid_attributes = %{}
      changeset = User.create_changeset(invalid_attributes)
      refute changeset.valid?
      assert errors_on(changeset) == %{username: ["can't be blank"], password: ["can't be blank"]}
    end
  end

  describe "changeset/2" do
    test "returns a valid changeset when parameters are valid" do
      attributes = params_for(:user)
      assert %Changeset{valid?: true} = User.changeset(%User{password_hash: UUID.generate()}, attributes)
    end

    test "returns a valid changeset and does not update balance neither password_hash fields" do
      password_hash = UUID.generate()
      balance = 500

      user = build(:user, balance: balance, password_hash: password_hash)

      changeset = User.changeset(user, %{balance: 0, password_hash: ""})
      assert %Changeset{valid?: true} = changeset
      assert %User{password_hash: ^password_hash, balance: ^balance} = apply_changes(changeset)
    end

    test "returns an invalid changeset when parameters are invalid" do
      invalid_attributes = %{}
      changeset = User.changeset(%User{}, invalid_attributes)
      refute changeset.valid?
      assert errors_on(changeset) == %{username: ["can't be blank"], password_hash: ["can't be blank"]}
    end
  end
end
