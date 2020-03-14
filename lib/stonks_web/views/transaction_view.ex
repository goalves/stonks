defmodule StonksWeb.TransactionView do
  use StonksWeb, :view
  alias StonksWeb.TransactionView

  @spec render(binary(), map()) :: map()
  def render("show.json", %{transaction: transaction}),
    do: %{data: render_one(transaction, TransactionView, "transaction.json")}

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      amount: transaction.amount,
      type: transaction.type,
      origin_user_id: transaction.origin_user_id,
      destination_user_id: transaction.destination_user_id
    }
  end
end
