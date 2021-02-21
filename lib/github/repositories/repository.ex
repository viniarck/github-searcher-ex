defmodule Github.Repositories.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "repo" do
    field :search_id, :binary_id
    field :deleted_at, :naive_datetime
    field :description, :string
    field :forks_count, :integer
    field :full_name, :string
    field :gh_created_at, :naive_datetime
    field :gh_id, :string
    field :gh_pushed_at, :naive_datetime
    field :gh_updated_at, :naive_datetime
    field :html_url, :string
    field :language, :string
    field :license, :map
    field :name, :string
    field :open_issues, :integer
    field :owner, :map
    field :private, :boolean, default: false
    field :stargazers_count, :integer
    field :watchers_count, :integer

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [
      :gh_id,
      :search_id,
      :name,
      :full_name,
      :html_url,
      :private,
      :description,
      :language,
      :stargazers_count,
      :watchers_count,
      :forks_count,
      :open_issues,
      :owner,
      :license,
      :gh_created_at,
      :gh_updated_at,
      :gh_pushed_at,
      :deleted_at
    ])
    |> validate_required([
      :gh_id,
      :name,
      :full_name,
      :private,
      :gh_created_at,
      :gh_updated_at
    ])
  end
end
