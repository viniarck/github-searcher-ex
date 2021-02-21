defmodule GithubWeb.RepositoryControllerTest do
  use GithubWeb.ConnCase

  alias Github.Repositories

  @create_attrs %{
    deleted_at: ~N[2010-04-17 14:00:00],
    description: "some description",
    forks_count: 42,
    full_name: "some full_name",
    gh_created_at: ~N[2010-04-17 14:00:00],
    gh_updated_at: ~N[2010-04-17 14:00:00],
    gh_id: "some gh_id",
    gh_pushed_at: ~N[2010-04-17 14:00:00],
    html_url: "some html_url",
    language: "some language",
    license: %{},
    name: "some name",
    open_issues: 42,
    owner: %{},
    private: true,
    stargazers_count: 42,
    watchers_count: 42
  }

  def fixture() do
    {:ok, repository} = Repositories.create_repository(@create_attrs)
    repository
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all repo", %{conn: conn} do
      conn = get(conn, Routes.repository_path(conn, :index))
      assert json_response(conn, 200)["items"] == []
    end

    test "lists all existing repos", %{conn: conn} do
      repo = fixture()
      conn = get(conn, Routes.repository_path(conn, :index))
      items = json_response(conn, 200)["items"]
      assert length(items) == 1
      assert Map.get(Enum.at(items, 0), "id") == Map.get(Map.from_struct(repo), :id)
    end
  end
end
