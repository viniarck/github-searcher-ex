defmodule GithubWeb.GhSearchView do
  use GithubWeb, :view
  alias GithubWeb.GhSearchView

  def render("index.json", %{repo: repo, total_count: total_count, page: page}) do
    %{
      items: render_many(repo, GhSearchView, "repository.json"),
      pagination: %{total_count: total_count, page: page}
    }
  end

  def render("show_400.json", %{detail: errors}) do
    %{detail: errors}
  end

  def render("repository.json", %{gh_search: repository}) do
    %{
      id: repository.id,
      search_id: repository.search_id,
      gh_id: repository.gh_id,
      name: repository.name,
      full_name: repository.full_name,
      html_url: repository.html_url,
      private: repository.private,
      description: repository.description,
      language: repository.language,
      stargazers_count: repository.stargazers_count,
      watchers_count: repository.watchers_count,
      forks_count: repository.forks_count,
      open_issues: repository.open_issues,
      owner: repository.owner,
      license: repository.license,
      gh_created_at: repository.gh_created_at,
      gh_pushed_at: repository.gh_pushed_at,
      gh_updated_at: repository.gh_updated_at,
      deleted_at: repository.deleted_at
    }
  end
end
