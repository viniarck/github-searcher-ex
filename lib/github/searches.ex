defmodule Github.Searches do
  @moduledoc """
  The Searches context.
  """

  import Ecto.Query, warn: false
  alias Github.Repo

  alias Github.Searches.Search

  @doc """
  Returns the list of search.

  ## Examples

      iex> list_search()
      [%Search{}, ...]

  """
  def list_search(page \\ 1, per_page \\ 1000) do
    query =
      from r in Search,
        offset: ^((page - 1) * per_page),
        limit: ^per_page

    {Repo.all(query), Repo.aggregate(Search, :count, :id)}
  end

  @doc """
  Gets a single search.

  Raises `Ecto.NoResultsError` if the Search does not exist.

  ## Examples

      iex> get_search!(123)
      %Search{}

      iex> get_search!(456)
      ** (Ecto.NoResultsError)

  """
  def get_search!(id), do: Repo.get!(Search, id)

  @doc """
  Creates a search.

  ## Examples

      iex> create_search(%{field: value})
      {:ok, %Search{}}

      iex> create_search(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_search(attrs \\ %{}) do
    %Search{}
    |> Search.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a search.

  ## Examples

      iex> update_search(search, %{field: new_value})
      {:ok, %Search{}}

      iex> update_search(search, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_search(%Search{} = search, attrs) do
    search
    |> Search.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking search changes.

  ## Examples

      iex> change_search(search)
      %Ecto.Changeset{data: %Search{}}

  """
  def change_search(%Search{} = search, attrs \\ %{}) do
    Search.changeset(search, attrs)
  end
end
