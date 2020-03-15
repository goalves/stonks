defmodule Stonks.Workers.WithdrawNotifierTest do
  use Stonks.DataCase, async: false

  import ExUnit.CaptureLog
  import Stonks.Factory
  import Swoosh.TestAssertions

  alias Oban.Job
  alias Stonks.Mailer.WithdrawEmail
  alias Stonks.Workers.WithdrawNotifier

  describe "perform/1" do
    test "generates an email" do
      transaction = insert(:withdraw_transaction)
      expected_email = WithdrawEmail.withdraw(transaction.origin_user, transaction)

      assert {:ok, text} = WithdrawNotifier.perform(%{"transaction_id" => transaction.id}, %Job{})
      assert_email_sent(expected_email)
    end

    @tag :capture_log
    test "returns an error when parameters are invalid",
      do: assert({:error, :invalid_parameters} == WithdrawNotifier.perform(%{}, %Job{}))

    test "logs errors when parameters do not match perform function" do
      function = fn -> WithdrawNotifier.perform(%{}, %Job{}) end

      assert capture_log(function) =~
               "Parameters did not match for notifying a withdraw: #{inspect(%{})}"
    end
  end
end
