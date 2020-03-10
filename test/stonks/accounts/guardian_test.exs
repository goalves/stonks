defmodule Stonks.Accounts.GuardianTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.UUID
  alias Stonks.Accounts.Guardian

  describe "subject_for_token/2" do
    test "returns the user_id of the encoded user" do
      user = build(:user)
      assert {:ok, user.id} == Guardian.subject_for_token(user, [])
    end

    test "returns an error if trying to encode a subject that is not an user" do
      assert {:error, :invalid_subject_for_token} == Guardian.subject_for_token(%{}, [])
    end
  end

  describe "resource_from_claims/2" do
    test "returns the user_id if the parameters are valid and the user exists" do
      user = insert(:user)
      params = %{"sub" => user.id}
      assert {:ok, user.id} == Guardian.resource_from_claims(params)
    end

    test "returns an error if the user in the token does not exist",
      do: assert({:error, :invalid_user_token} == Guardian.resource_from_claims(%{"sub" => UUID.generate()}))
  end
end
