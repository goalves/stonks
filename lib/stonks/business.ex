defmodule Stonks.Business do
  require Logger

  alias Ecto.{Changeset, Multi}
  alias Oban.Job
  alias Stonks.Accounts.User
  alias Stonks.Business.Transaction
  alias Stonks.Workers.WithdrawNotifier
  alias Stonks.{Accounts, Repo}

  @type transaction_response :: {:error, :transaction_does_not_exist} | {:ok, %Transaction{}}
  @type transaction_change_response :: {:ok, %Transaction{}} | {:error, Changeset.t()}

  @spec get_transaction(binary()) :: transaction_response
  def get_transaction(transaction_id) when is_binary(transaction_id) do
    Transaction
    |> Repo.get(transaction_id)
    |> case do
      transaction = %Transaction{} -> {:ok, transaction}
      _ -> {:error, :transaction_does_not_exist}
    end
  end

  @spec create_transaction(map()) :: transaction_change_response
  def create_transaction(attributes) when is_map(attributes) do
    Multi.new()
    |> Multi.insert(:transaction, Transaction.changeset(%Transaction{}, attributes))
    |> Multi.run(:user, fn _, %{transaction: transaction = %Transaction{}} ->
      update_users_for_transaction(transaction)
    end)
    |> Multi.run(:post_actions, fn _, %{transaction: transaction = %Transaction{}} ->
      post_create_actions(transaction)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{transaction: transaction = %Transaction{}}} -> {:ok, transaction}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  @spec update_users_for_transaction(%Transaction{}) :: {:ok, %User{}, %User{}} | {:error, Changeset.t()}
  defp update_users_for_transaction(transaction = %Transaction{type: "withdraw"}),
    do: update_user_balance(transaction, :origin_user)

  defp update_users_for_transaction(transaction = %Transaction{type: "transfer"}) do
    with {:ok, origin_user = %User{}} <- update_user_balance(transaction, :origin_user),
         {:ok, destination_user = %User{}} <- update_user_balance(transaction, :destination_user) do
      {:ok, {origin_user, destination_user}}
    end
  end

  @spec update_user_balance(%Transaction{}, atom()) :: {:ok, %User{}} | {:error, Changeset.t()}
  defp update_user_balance(transaction = %Transaction{amount: amount}, :origin_user) do
    user = transaction_user(transaction, :origin_user)
    Accounts.update_user_balance(user, user.balance - amount)
  end

  defp update_user_balance(transaction = %Transaction{amount: amount}, :destination_user) do
    user = transaction_user(transaction, :destination_user)
    Accounts.update_user_balance(user, user.balance + amount)
  end

  @spec transaction_user(%Transaction{}, atom()) :: map()
  defp transaction_user(transaction = %Transaction{}, user_atom) when user_atom in [:origin_user, :destination_user],
    do: transaction |> Repo.preload(user_atom) |> Map.fetch!(user_atom)

  defp post_create_actions(transaction = %Transaction{type: "withdraw", id: id, amount: amount}) do
    user = transaction_user(transaction, :origin_user)
    Logger.info("Withdraw #{id} for #{user.email} with amount #{amount}")

    with {:ok, _} <- notify_withdraw(transaction), do: {:ok, :action_performed}
  end

  defp post_create_actions(transaction = %Transaction{type: "transfer", id: id, amount: amount}) do
    origin_user = transaction_user(transaction, :origin_user)
    destination_user = transaction_user(transaction, :destination_user)

    Logger.info("Transfer #{id} from #{origin_user.email} to #{destination_user.email} with amount #{amount}")
    {:ok, :action_performed}
  end

  @spec notify_withdraw(%Transaction{}) :: {:ok, Job.t()} | {:error, Changeset.t()}
  defp notify_withdraw(transaction = %Transaction{}) do
    %{transaction_id: transaction.id}
    |> WithdrawNotifier.new()
    |> Oban.insert()
  end
end
