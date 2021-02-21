defmodule Github.Searches.Search do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "search" do
    field :deleted_at, :naive_datetime
    field :keywords, {:array, :string}
    field :qualifiers, {:array, :map}

    timestamps()
  end

  @doc false
  def changeset(search, attrs) do
    search
    |> cast(attrs, [:keywords, :qualifiers])
    |> validate_required_params(attrs)
  end

  def validate_required_params(search, %{:keywords => _}) do
    search
    |> validate_required(:keywords)
  end

  def validate_required_params(search, %{:qualifiers => _}) do
    search
    |> validate_required(:qualifiers)
  end

  def validate_required_params(search, %{:qualifiers => _, :keywords => _}) do
    search
    |> validate_required([:keywords, :qualifiers])
  end

  def validate_required_params(search, _params) do
    search
    |> add_error(:params, "Either :keywords or :qualifiers is required")
  end
end
