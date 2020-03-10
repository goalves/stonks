defmodule StonksWeb.UserView do
  use StonksWeb, :view
  alias StonksWeb.UserView

  @spec render(binary(), map()) :: map()
  def render("show.json", %{user: user}), do: %{data: render_one(user, UserView, "user.json")}

  def render("user.json", %{user: user}),
    do: %{id: user.id, username: user.username, password_hash: user.password_hash, balance: user.balance}
end
