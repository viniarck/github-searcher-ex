defmodule GithubWeb.RepositoryController do
  use GithubWeb, :controller

  alias Github.Repositories
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
        {repo, count} =
          Repositories.list_repo(
            Map.get(params, "search_id", ""),
            changeset.changes.page,
            changeset.changes.per_page
          )

        render(conn, "index.json", %{repo: repo, count: count, page: changeset.changes.page})

      false ->
        render(conn, "show_400.json", %{detail: changeset.errors |> hd |> elem(1) |> elem(0)})
    end
  end

  def show(conn, %{"id" => id}) do
    try do
      repository = Repositories.get_repository!(id)
      render(conn, "show.json", repository: repository)
    rescue
      _ -> render(conn |> put_status(404), "show_404.json", id: id)
    end
  end
end
