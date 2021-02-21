defmodule Github.Repo.Migrations.CreateSearch do
  use Ecto.Migration

  def change do
    create table(:search, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:keywords, {:array, :text})
      add(:qualifiers, :map)
      add(:deleted_at, :naive_datetime)

      timestamps()
    end
  end
end
