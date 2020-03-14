defmodule Stonks.Workers.WithdrawNotifier do
  use Oban.Worker, queue: :importers, max_attempts: 5

  require Logger

  alias Oban.Job
  alias Stonks.{Business, Mailer}
  alias Stonks.Business.Transaction

  @impl Oban.Worker
  @spec perform(any(), Job.t()) :: {:ok, atom()} | {:error, any}
  def perform(parameters = %{"transaction_id" => transaction_id}, job = %Job{}) when is_map(parameters) do
    Logger.info("Notifying user of withdraw for job #{inspect(job)}")

    with {:ok, transaction = %Transaction{}} <- Business.get_transaction(transaction_id) do
      Mailer.deliver("#{transaction.amount}")
    end
  end

  def perform(parameters, job = %Job{}) do
    Logger.error("Parameters did not match for notifying a withdraw: #{inspect(parameters)} on Job: #{inspect(job)}")
    {:error, :invalid_parameters}
  end
end
