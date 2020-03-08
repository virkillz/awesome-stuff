defmodule AwesomeGithub.Project.ListingRepository do
  use Ecto.Schema
  import Ecto.Changeset

  alias AwesomeGithub.Project

  schema "listing_repository" do
    field(:repository_name, :string, virtual: true)

    belongs_to(:listing, AwesomeGithub.Project.Listing)
    belongs_to(:repository, AwesomeGithub.Project.Repository)

    timestamps()
  end

  @doc false
  def changeset(listing_repository, attrs) do
    listing_repository
    |> cast(attrs, [:repository_name, :listing_id])
    |> validate_required([:repository_name, :listing_id])
    |> add_repository_id
    |> unique_constraint(:repository_name, name: :unique_repo_listing)
  end

  def add_repository_id(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{repository_name: repository_name}} ->
        # 1. strip url
        case Project.find_or_create_repository(repository_name) do
          {:ok, repo} -> changeset |> change(repository_id: repo.id)
          {:error, reason} -> add_error(changeset, :repository_name, reason)
        end

      _ ->
        changeset
    end
  end
end
