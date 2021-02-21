defmodule Github.RepositoriesTest do
  use Github.DataCase

  alias Github.Repositories

  describe "repo" do
    alias Github.Repositories.Repository

    @valid_attrs %{
      deleted_at: ~N[2010-04-17 14:00:00],
      description: "some description",
      forks_count: 42,
      full_name: "some full_name",
      gh_created_at: ~N[2010-04-17 14:00:00],
      gh_updated_at: ~N[2011-05-18 15:01:01],
      gh_id: "some gh_id",
      gh_pushed_at: ~N[2010-04-17 14:00:00],
      html_url: "some html_url",
      language: "some language",
      license: %{},
      name: "some name",
      open_issues: 42,
      owner: %{},
      private: true,
      stargazers_count: 42,
      watchers_count: 42
    }
    @update_attrs %{
      deleted_at: ~N[2011-05-18 15:01:01],
      description: "some updated description",
      forks_count: 43,
      full_name: "some updated full_name",
      gh_created_at: ~N[2011-05-18 15:01:01],
      gh_updated_at: ~N[2011-05-18 15:01:01],
      gh_pushed_at: ~N[2011-05-18 15:01:01],
      gh_id: "some updated gh_id",
      html_url: "some updated html_url",
      language: "some updated language",
      license: %{},
      name: "some updated name",
      open_issues: 43,
      owner: %{},
      private: false,
      stargazers_count: 43,
      watchers_count: 43
    }
    @invalid_attrs %{
      deleted_at: nil,
      description: nil,
      forks_count: nil,
      full_name: nil,
      gh_created_at: nil,
      gh_id: nil,
      gh_pushed_at: nil,
      html_url: nil,
      language: nil,
      license: nil,
      name: nil,
      open_issues: nil,
      owner: nil,
      private: nil,
      stargazers_count: nil,
      watchers_count: nil
    }

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Repositories.create_repository()

      repository
    end

    test "list_repo/1 returns all repo" do
      repository = repository_fixture()
      {repositories, count} = Repositories.list_repo()
      assert repositories == [repository]
      assert count > 0
    end

    test "list_repo/1 filter with search_id non existing" do
      _repository = repository_fixture()
      {repositories, count} = Repositories.list_repo(Ecto.UUID.generate())
      assert repositories == []
      assert count == 0
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Repositories.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Repositories.create_repository(@valid_attrs)
      assert repository.deleted_at == ~N[2010-04-17 14:00:00]
      assert repository.description == "some description"
      assert repository.forks_count == 42
      assert repository.full_name == "some full_name"
      assert repository.gh_created_at == ~N[2010-04-17 14:00:00]
      assert repository.gh_id == "some gh_id"
      assert repository.gh_pushed_at == ~N[2010-04-17 14:00:00]
      assert repository.html_url == "some html_url"
      assert repository.language == "some language"
      assert repository.license == %{}
      assert repository.name == "some name"
      assert repository.open_issues == 42
      assert repository.owner == %{}
      assert repository.private == true
      assert repository.stargazers_count == 42
      assert repository.watchers_count == 42
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, _} = Repositories.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()

      assert {:ok, %Repository{} = repository} =
               Repositories.update_repository(repository, @update_attrs)

      assert repository.deleted_at == ~N[2011-05-18 15:01:01]
      assert repository.description == "some updated description"
      assert repository.forks_count == 43
      assert repository.full_name == "some updated full_name"
      assert repository.gh_created_at == ~N[2011-05-18 15:01:01]
      assert repository.gh_id == "some updated gh_id"
      assert repository.gh_pushed_at == ~N[2011-05-18 15:01:01]
      assert repository.html_url == "some updated html_url"
      assert repository.language == "some updated language"
      assert repository.license == %{}
      assert repository.name == "some updated name"
      assert repository.open_issues == 43
      assert repository.owner == %{}
      assert repository.private == false
      assert repository.stargazers_count == 43
      assert repository.watchers_count == 43
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Repositories.update_repository(repository, @invalid_attrs)

      assert repository == Repositories.get_repository!(repository.id)
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Repositories.change_repository(repository)
    end
  end
end
