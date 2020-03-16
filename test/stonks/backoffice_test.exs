defmodule Stonks.BackofficeTest do
  use Stonks.DataCase, async: true
  use Oban.Testing, repo: Stonks.Repo
  use Timex

  import Stonks.Factory

  alias Stonks.Backoffice
  alias Stonks.Backoffice.Report

  describe "create_report/1" do
    test "returns a created report" do
      now = DateTime.utc_now() |> DateTime.truncate(:second)
      transaction = insert(:withdraw_transaction, datetime: now)
      attributes = params_for(:report_filter, start_datetime: now, end_datetime: now)

      assert {:ok, report = %Report{}} = Backoffice.create_report(attributes)
      assert report.start_datetime == now
      assert report.end_datetime == now
      assert report.total == transaction.amount
    end

    test "returns a created report with multiple transactions" do
      now = DateTime.utc_now() |> DateTime.truncate(:second)
      transactions = insert_list(10, :withdraw_transaction, datetime: now)
      attributes = params_for(:report_filter, start_datetime: now, end_datetime: now)

      assert {:ok, report = %Report{}} = Backoffice.create_report(attributes)
      assert report.start_datetime == now
      assert report.end_datetime == now
      assert report.total == Enum.reduce(transactions, 0, &(&1.amount + &2))
    end

    test "returns an error when report attributes are invalid",
      do: assert({:error, %Ecto.Changeset{}} = Backoffice.create_report(%{}))
  end
end
