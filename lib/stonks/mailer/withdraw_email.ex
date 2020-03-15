defmodule Stonks.Mailer.WithdrawEmail do
  use Phoenix.Swoosh, view: StonksWeb.EmailView, layout: {StonksWeb.LayoutView, :email}

  alias Stonks.Accounts.User
  alias Stonks.Business.Transaction

  @spec withdraw(%User{}, %Transaction{}) :: map()
  def withdraw(%User{name: name, email: email}, %Transaction{amount: amount}) do
    new()
    |> to({name, email})
    |> from({"Stonks", "no-reply@stonks.com"})
    |> subject("Receipt for Withdraw")
    |> render_body("withdraw.html", %{name: name, amount: amount})
  end
end
