defmodule GithubWeb.SearchController do
  use GithubWeb, :controller

  alias Github.Searches
  alias Github.Pagination.Paginated

  action_fallback GithubWeb.FallbackController

  def index(conn, params) do
    args = %{
      per_page: Map.get(params, "per_page", 10),
      page: Map.get(params, "page", 1)
    }

    changeset = Paginated.changeset(args)

    case changeset.valid? do
      true ->
        {search, count} = Searches.list_search(changeset.changes.page, changeset.changes.per_page)
        render(conn, "index.json", %{search: search, count: count, page: changeset.changes.page})

      false ->
        render(conn, "show_400.json", %{detail: changeset.errors |> hd |> elem(1) |> elem(0)})
    end
  end

  def show(conn, %{"id" => id}) do
    search = Searches.get_search!(id)
    render(conn, "show.json", search: search)
  end
end
