defmodule Github.SearchesTest do
  use Github.DataCase

  alias Github.Searches

  describe "search" do

    @valid_attrs %{
      deleted_at: ~N[2010-04-17 14:00:00],
      keywords: ["Elixir", "Python"],
      qualifiers: []
    }
    @invalid_attrs %{deleted_at: nil, keywords: nil, qualifiers: nil}

    def search_fixture(attrs \\ %{}) do
      {:ok, search} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Searches.create_search()

      search
    end

    test "create_search/1 valid" do
      search = search_fixture()
      assert search.id
      assert search.keywords == Map.get(@valid_attrs, :keywords)
      assert search.qualifiers == Map.get(@valid_attrs, :qualifiers)
    end

    test "list_search/0 returns all search" do
      search = search_fixture()
      {searches, count} = Searches.list_search()
      assert searches == [search]
      assert count > 0
    end

    test "get_search!/1 returns the search with given id" do
      search = search_fixture()
      assert Searches.get_search!(search.id) == search
    end

    test "create_search/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Searches.create_search(@invalid_attrs)
    end

    test "change_search/1 returns a search changeset" do
      search = search_fixture()
      assert %Ecto.Changeset{} = Searches.change_search(search)
    end
  end
end
