defmodule Stonks.Accounts do
  alias Ecto.{Changeset, Multi}
  alias Stonks.Accounts.{Operator, User}
  alias Stonks.Repo

  @type user_response :: {:error, :user_does_not_exist} | {:ok, %User{}}
  @type user_change_response :: {:ok, %User{}} | {:error, Changeset.t()}
  @type operator_response :: {:error, :operator_does_not_exist} | {:ok, %User{}}
  @type operator_change_response :: {:ok, %Operator{}} | {:error, Changeset.t()}

  @spec create_user(map()) :: user_change_response
  def create_user(attributes \\ %{}) do
    attributes
    |> User.create_changeset()
    |> Repo.insert()
  end

  @spec update_user(binary(), map()) :: user_change_response
  def update_user(user_id, attributes) when is_binary(user_id) and is_map(attributes) do
    Multi.new()
    |> Multi.run(:fetch, fn _, _ -> get_user(user_id) end)
    |> Multi.update(:update, fn %{fetch: user = %User{}} -> User.changeset(user, attributes) end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update: user = %User{}}} -> {:ok, user}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  @spec update_user_balance(%User{}, pos_integer()) :: user_change_response()
  def update_user_balance(user = %User{}, amount) when amount >= 0 do
    user
    |> User.balance_changeset(amount)
    |> Repo.update()
  end

  @spec get_user(binary()) :: user_response
  def get_user(id) when is_binary(id) do
    User
    |> Repo.get(id)
    |> case do
      user = %User{} -> {:ok, user}
      _ -> {:error, :user_does_not_exist}
    end
  end

  @spec get_user_by_email(binary()) :: user_response
  def get_user_by_email(email) when is_binary(email) do
    User
    |> Repo.get_by(email: email)
    |> case do
      user = %User{} -> {:ok, user}
      _ -> {:error, :user_does_not_exist}
    end
  end

  @spec create_operator(map()) :: operator_change_response
  def create_operator(attributes \\ %{}) do
    %Operator{}
    |> Operator.changeset(attributes)
    |> Repo.insert()
  end

  @spec get_operator_by_email(binary()) :: operator_response
  def get_operator_by_email(email) when is_binary(email) do
    Operator
    |> Repo.get_by(email: email)
    |> case do
      operator = %Operator{} -> {:ok, operator}
      _ -> {:error, :operator_does_not_exist}
    end
  end
end
