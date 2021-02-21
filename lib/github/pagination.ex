defmodule Github.Pagination do
  defmodule Paginated do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:per_page, :integer)
      field(:page, :integer)
    end

    @required_fields [:per_page, :page]

    def changeset(attrs) do
      %__MODULE__{}
      |> cast(attrs, @required_fields)
      |> validate_required(@required_fields)
      |> validate_required_values()
    end

    def validate_required_values(model) do
      case Enum.any?([
             Map.get(model.changes, :per_page) < 1,
             Map.get(model.changes, :page) < 1
           ]) do
        true ->
          model
          |> add_error(:params, "per_page and page must be positive integers")

        false ->
          model
      end
    end
  end
end
