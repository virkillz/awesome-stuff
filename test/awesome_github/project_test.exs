defmodule AwesomeGithub.ProjectTest do
  use AwesomeGithub.DataCase

  alias AwesomeGithub.Project

  describe "repositories" do
    alias AwesomeGithub.Project.Repository

    @valid_attrs %{
      archieved: true,
      creator: "some creator",
      custom_description: "some custom_description",
      fork_count: 42,
      git_url: "some git_url",
      html_url: "some html_url",
      language: "some language",
      last_commit: ~N[2010-04-17 14:00:00],
      last_update: ~N[2010-04-17 14:00:00],
      license: "some license",
      license_url: "some license_url",
      long_description: "some long_description",
      open_issues_count: 42,
      repo_created_date: ~N[2010-04-17 14:00:00],
      repo_fullname: "some repo_fullname",
      repo_name: "some repo_name",
      short_description: "some short_description",
      star_count: 42
    }
    @update_attrs %{
      archieved: false,
      creator: "some updated creator",
      custom_description: "some updated custom_description",
      fork_count: 43,
      git_url: "some updated git_url",
      html_url: "some updated html_url",
      language: "some updated language",
      last_commit: ~N[2011-05-18 15:01:01],
      last_update: ~N[2011-05-18 15:01:01],
      license: "some updated license",
      license_url: "some updated license_url",
      long_description: "some updated long_description",
      open_issues_count: 43,
      repo_created_date: ~N[2011-05-18 15:01:01],
      repo_fullname: "some updated repo_fullname",
      repo_name: "some updated repo_name",
      short_description: "some updated short_description",
      star_count: 43
    }
    @invalid_attrs %{
      archieved: nil,
      creator: nil,
      custom_description: nil,
      fork_count: nil,
      git_url: nil,
      html_url: nil,
      language: nil,
      last_commit: nil,
      last_update: nil,
      license: nil,
      license_url: nil,
      long_description: nil,
      open_issues_count: nil,
      repo_created_date: nil,
      repo_fullname: nil,
      repo_name: nil,
      short_description: nil,
      star_count: nil
    }

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Project.create_repository()

      repository
    end

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Project.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Project.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Project.create_repository(@valid_attrs)
      assert repository.archieved == true
      assert repository.creator == "some creator"
      assert repository.custom_description == "some custom_description"
      assert repository.fork_count == 42
      assert repository.git_url == "some git_url"
      assert repository.html_url == "some html_url"
      assert repository.language == "some language"
      assert repository.last_commit == ~N[2010-04-17 14:00:00]
      assert repository.last_update == ~N[2010-04-17 14:00:00]
      assert repository.license == "some license"
      assert repository.license_url == "some license_url"
      assert repository.long_description == "some long_description"
      assert repository.open_issues_count == 42
      assert repository.repo_created_date == ~N[2010-04-17 14:00:00]
      assert repository.repo_fullname == "some repo_fullname"
      assert repository.repo_name == "some repo_name"
      assert repository.short_description == "some short_description"
      assert repository.star_count == 42
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Project.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()

      assert {:ok, %Repository{} = repository} =
               Project.update_repository(repository, @update_attrs)

      assert repository.archieved == false
      assert repository.creator == "some updated creator"
      assert repository.custom_description == "some updated custom_description"
      assert repository.fork_count == 43
      assert repository.git_url == "some updated git_url"
      assert repository.html_url == "some updated html_url"
      assert repository.language == "some updated language"
      assert repository.last_commit == ~N[2011-05-18 15:01:01]
      assert repository.last_update == ~N[2011-05-18 15:01:01]
      assert repository.license == "some updated license"
      assert repository.license_url == "some updated license_url"
      assert repository.long_description == "some updated long_description"
      assert repository.open_issues_count == 43
      assert repository.repo_created_date == ~N[2011-05-18 15:01:01]
      assert repository.repo_fullname == "some updated repo_fullname"
      assert repository.repo_name == "some updated repo_name"
      assert repository.short_description == "some updated short_description"
      assert repository.star_count == 43
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Project.update_repository(repository, @invalid_attrs)
      assert repository == Project.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Project.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Project.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Project.change_repository(repository)
    end
  end

  describe "listing" do
    alias AwesomeGithub.Project.Listing

    @valid_attrs %{description: "some description", is_active: true, name: "some name"}
    @update_attrs %{description: "some updated description", is_active: false, name: "some updated name"}
    @invalid_attrs %{description: nil, is_active: nil, name: nil}

    def listing_fixture(attrs \\ %{}) do
      {:ok, listing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Project.create_listing()

      listing
    end

    test "list_listing/0 returns all listing" do
      listing = listing_fixture()
      assert Project.list_listing() == [listing]
    end

    test "get_listing!/1 returns the listing with given id" do
      listing = listing_fixture()
      assert Project.get_listing!(listing.id) == listing
    end

    test "create_listing/1 with valid data creates a listing" do
      assert {:ok, %Listing{} = listing} = Project.create_listing(@valid_attrs)
      assert listing.description == "some description"
      assert listing.is_active == true
      assert listing.name == "some name"
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Project.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{} = listing} = Project.update_listing(listing, @update_attrs)
      assert listing.description == "some updated description"
      assert listing.is_active == false
      assert listing.name == "some updated name"
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Project.update_listing(listing, @invalid_attrs)
      assert listing == Project.get_listing!(listing.id)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = Project.delete_listing(listing)
      assert_raise Ecto.NoResultsError, fn -> Project.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = Project.change_listing(listing)
    end
  end

  describe "listing_repository" do
    alias AwesomeGithub.Project.ListingRepository

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def listing_repository_fixture(attrs \\ %{}) do
      {:ok, listing_repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Project.create_listing_repository()

      listing_repository
    end

    test "list_listing_repository/0 returns all listing_repository" do
      listing_repository = listing_repository_fixture()
      assert Project.list_listing_repository() == [listing_repository]
    end

    test "get_listing_repository!/1 returns the listing_repository with given id" do
      listing_repository = listing_repository_fixture()
      assert Project.get_listing_repository!(listing_repository.id) == listing_repository
    end

    test "create_listing_repository/1 with valid data creates a listing_repository" do
      assert {:ok, %ListingRepository{} = listing_repository} = Project.create_listing_repository(@valid_attrs)
    end

    test "create_listing_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Project.create_listing_repository(@invalid_attrs)
    end

    test "update_listing_repository/2 with valid data updates the listing_repository" do
      listing_repository = listing_repository_fixture()
      assert {:ok, %ListingRepository{} = listing_repository} = Project.update_listing_repository(listing_repository, @update_attrs)
    end

    test "update_listing_repository/2 with invalid data returns error changeset" do
      listing_repository = listing_repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Project.update_listing_repository(listing_repository, @invalid_attrs)
      assert listing_repository == Project.get_listing_repository!(listing_repository.id)
    end

    test "delete_listing_repository/1 deletes the listing_repository" do
      listing_repository = listing_repository_fixture()
      assert {:ok, %ListingRepository{}} = Project.delete_listing_repository(listing_repository)
      assert_raise Ecto.NoResultsError, fn -> Project.get_listing_repository!(listing_repository.id) end
    end

    test "change_listing_repository/1 returns a listing_repository changeset" do
      listing_repository = listing_repository_fixture()
      assert %Ecto.Changeset{} = Project.change_listing_repository(listing_repository)
    end
  end
end
