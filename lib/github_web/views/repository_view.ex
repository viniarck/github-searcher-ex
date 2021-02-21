defmodule GithubWeb.RepositoryView do
  use GithubWeb, :view
  alias GithubWeb.RepositoryView

  def render("index.json", %{repo: repo, count: count, page: page}) do
    %{
      items: render_many(repo, RepositoryView, "repository.json"),
      pagination: %{total_count: count, page: page}
    }
  end

  def render("show.json", %{repository: repository}) do
    %{data: render_one(repository, RepositoryView, "repository.json")}
  end

  def render("show_404.json", %{id: id}) do
    %{detail: "id #{id} not found"}
  end

  def render("show_400.json", %{detail: errors}) do
    %{detail: errors}
  end

  def render("repository.json", %{repository: repository}) do
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
