defmodule StonksWeb.UserView do
  use StonksWeb, :view
  alias StonksWeb.UserView

  @spec render(binary(), map()) :: map()
  def render("show.json", %{user: user}), do: %{data: render_one(user, UserView, "user.json")}

  def render("user.json", %{user: user}),
    do: %{id: user.id, name: user.name, email: user.email, balance: user.balance}
end
