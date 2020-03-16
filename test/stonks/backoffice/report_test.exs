defmodule Stonks.Backoffice.ReportTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.Changeset
  alias Stonks.Backoffice.Report

  describe "new/1" do
    test "returns a tuple with a valid structure when parameters are valid" do
      attributes = params_for(:report)
      assert {:ok, report = %Report{}} = Report.new(attributes)
      assert report.start_datetime == attributes.start_datetime
      assert report.end_datetime == attributes.end_datetime
      assert report.total == attributes.total
    end

    test "returns a tuple with an invalid changeset when parameters are missing" do
      assert {:error, changeset = %Changeset{valid?: false}} = Report.new(%{})

      assert errors_on(changeset) == %{
               start_datetime: ["can't be blank"],
               total: ["can't be blank"]
             }
    end
  end
end
