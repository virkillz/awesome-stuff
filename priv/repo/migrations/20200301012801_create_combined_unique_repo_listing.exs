defmodule AwesomeGithub.Repo.Migrations.CreateCombinedUniqueRepoListing do
  use Ecto.Migration

  def change do
    create(
      unique_index(:listing_repository, [:repository_id, :listing_id], name: :unique_repo_listing)
    )
  end
end
