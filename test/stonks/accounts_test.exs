defmodule Stonks.AccountsTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.{Changeset, UUID}
  alias Faker.{Internet, Name}
  alias Stonks.Accounts
  alias Stonks.Accounts.{Operator, User}

  describe "get_user/1" do
    test "returns the user with the given id" do
      user = insert(:user)
      assert {:ok, fetch_user = %User{}} = Accounts.get_user(user.id)
      assert fetch_user.id == user.id
    end

    test "returns an error if the an user with the specified id does not exist",
      do: assert({:error, :user_does_not_exist} == Accounts.get_user(UUID.generate()))
  end

  describe "get_user_by_email/1" do
    test "returns the user with the given email" do
      user = insert(:user)
      assert {:ok, fetch_user = %User{}} = Accounts.get_user_by_email(user.email)
      assert fetch_user.id == user.id
    end

    test "returns an error if the an user with the specified id does not exist",
      do: assert({:error, :user_does_not_exist} == Accounts.get_user_by_email(Internet.email()))
  end

  describe "create_user/1" do
    test "returns a created user" do
      attributes = :user |> params_for() |> Map.drop([:balance, :password_hash])
      assert {:ok, user = %User{id: id}} = Accounts.create_user(attributes)
      refute is_nil(user.password_hash)
      assert user.balance == 100_000
      refute User |> Repo.get(id) |> is_nil()
    end

    test "returns an error when user attributes are invalid",
      do: assert({:error, %Changeset{}} = Accounts.create_user(%{}))
  end

  describe "update_user/1" do
    setup do
      %{user: insert(:user)}
    end

    test "returns an updated user when passing the id", %{user: user} do
      new_name = Name.name()
      attributes = %{name: new_name}

      assert {:ok, user = %User{}} = Accounts.update_user(user.id, attributes)
      assert user.name == new_name
    end

    test "returns an error when the user does not exist",
      do: assert({:error, :user_does_not_exist} == Accounts.update_user(UUID.generate(), %{}))

    test("returns an error when user attributes are invalid", %{user: user},
      do: assert({:error, %Changeset{}} = Accounts.update_user(user.id, %{email: nil}))
    )
  end

  describe "create_operator/1" do
    test "returns a created operator" do
      attributes = params_for(:operator)
      assert {:ok, operator = %Operator{id: id}} = Accounts.create_operator(attributes)
      refute is_nil(operator.password_hash)
      refute Operator |> Repo.get(id) |> is_nil()
    end

    test "returns an error when user attributes are invalid",
      do: assert({:error, %Changeset{}} = Accounts.create_operator(%{}))
  end

  describe "get_operator_by_email/1" do
    test "returns the operator with the given email" do
      operator = insert(:operator)
      assert {:ok, fetch_operator = %Operator{}} = Accounts.get_operator_by_email(operator.email)
      assert fetch_operator.id == operator.id
    end

    test "returns an error if the an operator with the specified id does not exist",
      do: assert({:error, :operator_does_not_exist} == Accounts.get_operator_by_email(Internet.email()))
  end
end
