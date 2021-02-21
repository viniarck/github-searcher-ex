defmodule Github.Client do
  @moduledoc """
  GitHub REST API client module, for a reference see
  https://docs.github.com/en/rest/reference/search
  """
  require Logger

  defmodule ReposSearch do
    defstruct keywords: [],
              qualifiers: [],
              accept: "application/vnd.github.v3+json",
              sort: "stars",
              order: "desc",
              per_page: 5,
              page: 1
  end

  defmodule ReposSearchResp do
    defstruct [:items, :incomplete_results, :total_count]
  end

  defmodule ReposSearchModel do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:keywords, {:array, :string})
      field(:qualifiers, {:array, :map})
      field(:per_page, :integer)
      field(:page, :integer)
    end

    @required_fields [:keywords, :qualifiers, :per_page, :page]

    def changeset(attrs) do
      %__MODULE__{}
      |> cast(attrs, @required_fields)
      |> validate_required(@required_fields)
      |> validate_required_per_page_limit()
    end

    def validate_required_per_page_limit(search) do
      case Enum.any?([
             Map.get(search.changes, :per_page) < 1,
             Map.get(search.changes, :per_page) > 1000
           ]) do
        true ->
          search
          |> add_error(:params, "GitHub repo search API limits up to 1000 results")

        false ->
          search
      end
    end
  end

  def map_search(%ReposSearch{} = model, endpoint \\ "/search/repositories?q=") do
    qualifiers =
      model.qualifiers
      |> Enum.map(fn qualifier_map ->
        Enum.reduce(Map.keys(qualifier_map), [], fn key, acc ->
          [key <> ":" <> Map.get(qualifier_map, key) | acc]
        end)
      end)
      |> List.flatten()

    keywords_qualifiers =
      [Enum.join(model.keywords, " "), Enum.join(qualifiers, " ")]
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.join(" ")

    query_args =
      [
        keywords_qualifiers
        | [
            "accept=#{model.accept}",
            "sort=#{model.sort}",
            "order=#{model.order}",
            "per_page=#{model.per_page}",
            "page=#{model.page}"
          ]
      ]
      |> Enum.join("&")

    endpoint <> query_args
  end

  def search_repos(client, %ReposSearch{} = model) do
    url = model |> map_search() |> URI.encode()
    # TODO TTL-based cache KV for the response

    Logger.info("search_repos search query args #{url}")
    {res, content} = Tesla.get(client, url)
    body = content.body

    case Map.get(body, "incomplete_results") do
      true -> res
      false -> {:error, "incomplete results"}
    end

    {res,
     %ReposSearchResp{
       items: Map.get(body, "items"),
       incomplete_results: Map.get(body, "incomplete_results"),
       total_count: Map.get(body, "total_count")
     }}
  end

  def new(extra_headers \\ []) when is_list(extra_headers) do
    headers =
      Enum.chunk_every(extra_headers, 2)
      |> Enum.map(&List.to_tuple(&1))
      |> Enum.concat([{"User-Agent", "tesla"}])

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, headers},
      {Tesla.Middleware.Retry,
       delay: 1000,
       max_retries: 5,
       max_delay: 2000,
       should_retry: fn
         {:ok, %{status: status}} when status in [500] -> true
         {:error, _} -> true
         _ -> false
       end}
    ]

    Tesla.client(middleware)
  end
end
