defmodule Github.Repositories do
  @moduledoc """
  The Repositories context.
  """

  import Ecto.Query, warn: false
  alias Github.Repo

  alias Github.Repositories.Repository

  @doc """
  Returns the list of repo.

  ## Examples

      iex> list_repo()
      [{%Repository{}, ...}, total_count]

  """
  def list_repo(search_id \\ "", page \\ 1, per_page \\ 1000) do
    {elems, query} =
      case search_id != "" do
        true ->
          query =
            from r in Repository,
              where: r.search_id == ^search_id,
              offset: ^((page - 1) * per_page),
              limit: ^per_page

          query_count =
            from r in Repository,
              where: r.search_id == ^search_id

          {Repo.all(query), query_count}

        false ->
          query =
            from r in Repository,
              offset: ^((page - 1) * per_page),
              limit: ^per_page

          {Repo.all(query), from r in Repository}
      end

    {elems, Repo.aggregate(query, :count, :id)}
  end

  @doc """
  Gets a single repository.

  Raises `Ecto.NoResultsError` if the Repository does not exist.

  ## Examples

      iex> get_repository!(123)
      %Repository{}

      iex> get_repository!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repository!(id), do: Repo.get!(Repository, id)

  @doc """
  Creates a repository.

  ## Examples

      iex> create_repository(%{field: value})
      {:ok, %Repository{}}

      iex> create_repository(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repository(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a repository.

  ## Examples

      iex> update_repository(repository, %{field: new_value})
      {:ok, %Repository{}}

      iex> update_repository(repository, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_repository(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repository changes.

  ## Examples

      iex> change_repository(repository)
      %Ecto.Changeset{data: %Repository{}}

  """
  def change_repository(%Repository{} = repository, attrs \\ %{}) do
    Repository.changeset(repository, attrs)
  end
end
