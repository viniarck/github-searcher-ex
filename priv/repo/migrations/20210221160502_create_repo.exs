defmodule Github.Repo.Migrations.CreateRepo do
  use Ecto.Migration

  def change do
    create table(:repo, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:search_id, references(:search, type: :binary_id, on_delete: :delete_all))
      add(:gh_id, :text, null: false)
      add(:name, :text, null: false)
      add(:full_name, :text, null: false)
      add(:html_url, :text)
      add(:private, :boolean, null: false)
      add(:description, :text)
      add(:language, :text)
      add(:stargazers_count, :integer)
      add(:watchers_count, :integer)
      add(:forks_count, :integer)
      add(:open_issues, :integer)
      add(:owner, :map)
      add(:license, :map)
      add(:gh_created_at, :naive_datetime, null: false)
      add(:gh_updated_at, :naive_datetime, null: false)
      add(:gh_pushed_at, :naive_datetime)
      add(:deleted_at, :naive_datetime)

      timestamps()
    end
  end
end
