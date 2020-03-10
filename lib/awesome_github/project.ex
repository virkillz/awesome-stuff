defmodule AwesomeGithub.Project do
  @moduledoc """
  The Project context.
  """

  import Ecto.Query, warn: false
  alias AwesomeGithub.Repo

  alias AwesomeGithub.Project.Repository

  @doc """
  Returns the list of repositories.

  ## Examples

      iex> list_repositories()
      [%Repository{}, ...]

  """
  def list_repositories do
    Repo.all(Repository)
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

  def get_repository_by_fullname(full_name) do
    query =
      from(r in Repository,
        where: r.repo_fullname == ^full_name
      )

    Repo.one(query)
  end

  # utility
  def tolerate_url_entry(params) do
    Map.put(params, "repo_fullname", url_to_repo_name(params["repo_fullname"]))
  end

  # utility
  def url_to_repo_name(maybe_url) do
    cond do
      String.contains?(maybe_url, ".git") ->
        maybe_url |> String.trim_leading("https://github.com/") |> String.trim_trailing(".git")

      String.contains?(maybe_url, "https://github.com/") ->
        maybe_url |> String.trim_leading("https://github.com/")

      true ->
        maybe_url
    end
  end

  def find_or_create_repository(repository_name) do
    repository = repository_name |> url_to_repo_name() |> get_repository_by_fullname

    if is_nil(repository) do
      case create_repository(
             %{"repo_fullname" => repository_name}
             |> tolerate_url_entry()
           ) do
        {:ok, repository} ->
          {:ok, repository}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:error, "Most Likely Repo not founded"}
      end
    else
      {:ok, repository}
    end
  end

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
  Deletes a Repository.

  ## Examples

      iex> delete_repository(repository)
      {:ok, %Repository{}}

      iex> delete_repository(repository)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repository(%Repository{} = repository) do
    Repo.delete(repository)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repository changes.

  ## Examples

      iex> change_repository(repository)
      %Ecto.Changeset{source: %Repository{}}

  """
  def change_repository(%Repository{} = repository) do
    Repository.changeset(repository, %{})
  end

  alias AwesomeGithub.Project.Listing

  @doc """
  Returns the list of listing.

  ## Examples

      iex> list_listing()
      [%Listing{}, ...]

  """
  def list_listing do
    # Repo.all(Listing)
    query = from(l in Listing, preload: [:parent])
    Repo.all(query)
  end

  def list_listing_by_parent_id(id) do
    query =
      from(l in Listing,
        where: l.parent_id == ^id
      )

    Repo.all(query)
  end

  def parent_normalize(map_of_listing) do
  end

  @doc """
  Gets a single listing.

  Raises `Ecto.NoResultsError` if the Listing does not exist.

  ## Examples

      iex> get_listing!(123)
      %Listing{}

      iex> get_listing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing!(id) do
  
  query = from l in Listing,
    where: l.id == ^id,
    preload: [listing_repository: [:repository]]

   Repo.one!(query)
  end
  @doc """
  Creates a listing.

  ## Examples

      iex> create_listing(%{field: value})
      {:ok, %Listing{}}

      iex> create_listing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_listing(attrs \\ %{}) do
    %Listing{}
    |> Listing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a listing.

  ## Examples

      iex> update_listing(listing, %{field: new_value})
      {:ok, %Listing{}}

      iex> update_listing(listing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_listing(%Listing{} = listing, attrs) do
    listing
    |> Listing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a listing.

  ## Examples

      iex> delete_listing(listing)
      {:ok, %Listing{}}

      iex> delete_listing(listing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_listing(%Listing{} = listing) do
    Repo.delete(listing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking listing changes.

  ## Examples

      iex> change_listing(listing)
      %Ecto.Changeset{source: %Listing{}}

  """
  def change_listing(%Listing{} = listing) do
    Listing.changeset(listing, %{})
  end

  alias AwesomeGithub.Project.ListingRepository

  @doc """
  Returns the list of listing_repository.

  ## Examples

      iex> list_listing_repository()
      [%ListingRepository{}, ...]

  """
  def list_listing_repository do
    query =
      from(l in ListingRepository,
        preload: [:repository, :listing]
      )

    Repo.all(query)
  end

  @doc """
  Gets a single listing_repository.

  Raises `Ecto.NoResultsError` if the Listing repository does not exist.

  ## Examples

      iex> get_listing_repository!(123)
      %ListingRepository{}

      iex> get_listing_repository!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing_repository!(id), do: Repo.get!(ListingRepository, id)


  def list_listing_repository_by_listing_id(id) do
        query =
      from(l in ListingRepository,
        where: l.listing_id == ^id,
        preload: [:repository, :listing]
      )

    Repo.all(query)
  end

  @doc """
  Creates a listing_repository.

  ## Examples

      iex> create_listing_repository(%{field: value})
      {:ok, %ListingRepository{}}

      iex> create_listing_repository(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_listing_repository(attrs \\ %{}) do
    %ListingRepository{}
    |> ListingRepository.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a listing_repository.

  ## Examples

      iex> update_listing_repository(listing_repository, %{field: new_value})
      {:ok, %ListingRepository{}}

      iex> update_listing_repository(listing_repository, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_listing_repository(%ListingRepository{} = listing_repository, attrs) do
    listing_repository
    |> ListingRepository.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a listing_repository.

  ## Examples

      iex> delete_listing_repository(listing_repository)
      {:ok, %ListingRepository{}}

      iex> delete_listing_repository(listing_repository)
      {:error, %Ecto.Changeset{}}

  """
  def delete_listing_repository(%ListingRepository{} = listing_repository) do
    Repo.delete(listing_repository)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking listing_repository changes.

  ## Examples

      iex> change_listing_repository(listing_repository)
      %Ecto.Changeset{source: %ListingRepository{}}

  """
  def change_listing_repository(%ListingRepository{} = listing_repository) do
    ListingRepository.changeset(listing_repository, %{})
  end
end
