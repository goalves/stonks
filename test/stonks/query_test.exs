defmodule Stonks.QueryTest do
  use Stonks.DataCase, async: true

  alias Ecto.Changeset
  alias Faker.Lorem
  alias Stonks.Query

  describe "parse_filters/2" do
    test "should parse a simple filter for a string value" do
      key_string = Lorem.word()
      # credo:disable-for-next-line
      key = String.to_atom(key_string)
      acceptable_filters = %{key => :string}
      value = key_string
      params = %{key_string => value}

      assert {:ok, %{key => value}} == Query.parse_filters(acceptable_filters, params)
    end

    test "returns an error if the value type is wrong" do
      key_string = Lorem.word()
      # credo:disable-for-next-line
      key = String.to_atom(key_string)
      acceptable_filters = %{key => :string}
      integer_value = 1
      params = %{key_string => integer_value}

      assert {:error, changeset = %Changeset{}} = Query.parse_filters(acceptable_filters, params)
      assert errors_on(changeset) == %{key => ["is invalid"]}
    end
  end
end
