defmodule Stonks.AccountsTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.UUID
  alias Faker.Internet
  alias Stonks.Accounts
  alias Stonks.Accounts.User

  describe "get_user/1" do
    test "returns an the user with the given id" do
      user = insert(:user)
      assert {:ok, fetch_user = %User{}} = Accounts.get_user(user.id)
      assert fetch_user.id == user.id
    end

    test "returns an error if the an user with the specified id does not exist",
      do: assert({:error, :user_does_not_exist} == Accounts.get_user(UUID.generate()))
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
      do: assert({:error, %Ecto.Changeset{}} = Accounts.create_user(%{}))
  end

  describe "update_user/1" do
    setup do
      %{user: insert(:user)}
    end

    test "returns an updated user when passing the id", %{user: user} do
      new_username = Internet.user_name()
      attributes = %{username: new_username}

      assert {:ok, user = %User{}} = Accounts.update_user(user.id, attributes)
      assert user.username == new_username
    end

    test "returns an error when the user does not exist",
      do: assert({:error, :user_does_not_exist} == Accounts.update_user(UUID.generate(), %{}))

    test("returns an error when user attributes are invalid", %{user: user},
      do: assert({:error, %Ecto.Changeset{}} = Accounts.update_user(user.id, %{username: nil}))
    )
  end
end
