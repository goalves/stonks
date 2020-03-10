defmodule Stonks.Accounts do
  alias Ecto.{Changeset, Multi}
  alias Stonks.Accounts.User
  alias Stonks.Repo

  @type user_response :: {:error, :user_does_not_exist} | {:ok, %User{}}
  @type user_change_response :: {:ok, %User{}} | {:error, Changeset.t()}

  @spec create_user(map()) :: user_change_response
  def create_user(attrs \\ %{}) do
    attrs
    |> User.create_changeset()
    |> Repo.insert()
  end

  @spec update_user(binary(), map()) :: user_change_response
  def update_user(user_id, attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:fetch, fn _, _ -> get_user(user_id) end)
    |> Multi.update(:update, fn %{fetch: user = %User{}} -> User.changeset(user, attrs) end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update: user = %User{}}} -> {:ok, user}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  @spec get_user(binary) :: user_response
  def get_user(id) when is_binary(id) do
    User
    |> Repo.get(id)
    |> case do
      user = %User{} -> {:ok, user}
      _ -> {:error, :user_does_not_exist}
    end
  end

  @spec get_user_by_username(binary) :: user_response
  def get_user_by_username(username) do
    User
    |> Repo.get_by(username: username)
    |> case do
      user = %User{} -> {:ok, user}
      _ -> {:error, :user_does_not_exist}
    end
  end
end
