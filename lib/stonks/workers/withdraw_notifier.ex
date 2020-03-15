defmodule Stonks.Workers.WithdrawNotifier do
  use Oban.Worker, queue: :importers, max_attempts: 5

  require Logger

  alias Oban.Job
  alias Stonks.{Accounts, Business, Mailer}
  alias Stonks.Accounts.User
  alias Stonks.Business.Transaction
  alias Stonks.Mailer.WithdrawEmail

  @impl Oban.Worker
  @spec perform(any(), Job.t()) :: {:ok, atom()} | {:error, any}
  def perform(parameters = %{"transaction_id" => transaction_id}, job = %Job{}) when is_map(parameters) do
    Logger.info("Notifying user of withdraw for job #{inspect(job)}")

    with {:ok, transaction = %Transaction{}} <- Business.get_transaction(transaction_id),
         {:ok, user = %User{}} <- Accounts.get_user(transaction.origin_user_id) do
      user
      |> WithdrawEmail.withdraw(transaction)
      |> Mailer.deliver()
    end
  end

  def perform(parameters, job = %Job{}) do
    Logger.error("Parameters did not match for notifying a withdraw: #{inspect(parameters)} on Job: #{inspect(job)}")
    {:error, :invalid_parameters}
  end
end
