defmodule GithubWeb.GhSearchController do
  use GithubWeb, :controller

  alias Github.Client
  alias Github.Searches
  alias Github.Repositories

  action_fallback GithubWeb.FallbackController

  def create(conn, params) do
    args = %{
      keywords: Map.get(params, "keywords", []),
      qualifiers: Map.get(params, "qualifiers", []),
      per_page: Map.get(params, "per_page", 5),
      page: Map.get(params, "page", 1)
    }

    changeset = Client.ReposSearchModel.changeset(args)

    case changeset.valid? do
      true ->
        {:ok, resp} =
          Client.new()
          |> Client.search_repos(struct(Client.ReposSearch, changeset.changes))

        {:ok, search} =
          Searches.create_search(%{keywords: args.keywords, qualifiers: args.qualifiers})

        from_to_keys = %{
          "id" => "gh_id",
          "updated_at" => "gh_updated_at",
          "created_at" => "gh_created_at",
          "pushed_at" => "gh_pushed_at"
        }

        items =
          resp.items
          |> Enum.map(fn item ->
            Enum.reduce(Map.keys(from_to_keys), item, fn val, acc ->
              Map.put(acc, Map.get(from_to_keys, val), Map.get(acc, val))
            end)
          end)
          |> Enum.map(fn item ->
            Map.delete(item, "id")
            |> Map.put("gh_id", Map.get(item, "gh_id") |> to_string)
            |> Map.put("search_id", search.id)
          end)

        # TODO update_all with bulk_insert
        values =
          Enum.reduce(items, [], fn x, acc ->
            {:ok, r} = Repositories.create_repository(x)
            [r | acc]
          end)

        render(conn, "index.json", %{
          repo: values,
          total_count: resp.total_count,
          page: changeset.changes.page
        })

      false ->
        render(conn, "show_400.json", %{detail: changeset.errors |> hd |> elem(1) |> elem(0)})
    end
  end
end
