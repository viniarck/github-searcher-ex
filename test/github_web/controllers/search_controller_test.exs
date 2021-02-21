defmodule GithubWeb.SearchControllerTest do
  use GithubWeb.ConnCase

  alias Github.Searches

  @create_attrs %{
    deleted_at: ~N[2010-04-17 14:00:00],
    keywords: [],
    qualifiers: %{}
  }

  def fixture(:search) do
    {:ok, search} = Searches.create_search(@create_attrs)
    search
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all search", %{conn: conn} do
      conn = get(conn, Routes.search_path(conn, :index))
      assert json_response(conn, 200)["items"] == []
    end
  end
end
