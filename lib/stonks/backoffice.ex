defmodule Stonks.Backoffice do
  alias Stonks.Business
  alias Stonks.Business.Transaction
  alias Stonks.Backoffice.{Report, ReportFilter}

  def create_report(attributes \\ %{}) do
    with {:ok, %ReportFilter{start_datetime: report_start, end_datetime: report_end}} <-
           ReportFilter.new(attributes),
         {:ok, transactions} <- Business.list_transactions_on_period(report_start, report_end) do
      total = sum_total(transactions)
      Report.new(%{start_datetime: report_start, end_datetime: report_end, total: total})
    end
  end

  def sum_total(transactions) when is_list(transactions),
    do: Enum.reduce(transactions, 0, fn %Transaction{amount: amount}, acc -> acc + amount end)
end
