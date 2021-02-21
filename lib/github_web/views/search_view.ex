defmodule GithubWeb.SearchView do
  use GithubWeb, :view
  alias GithubWeb.SearchView

  def render("index.json", %{search: search, count: count, page: page}) do
    %{
      items: render_many(search, SearchView, "search.json"),
      pagination: %{total_count: count, page: page}
    }
  end

  def render("show.json", %{search: search}) do
    %{data: render_one(search, SearchView, "search.json")}
  end

  def render("show_400.json", %{detail: errors}) do
    %{detail: errors}
  end

  def render("search.json", %{search: search}) do
    %{
      id: search.id,
      keywords: search.keywords,
      qualifiers: search.qualifiers,
      deleted_at: search.deleted_at
    }
  end
end
