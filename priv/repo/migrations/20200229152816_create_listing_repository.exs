defmodule AwesomeGithub.Repo.Migrations.CreateListingRepository do
  use Ecto.Migration

  def change do
    create table(:listing_repository) do
      add(:repository_id, references(:repositories, on_delete: :nothing))
      add(:listing_id, references(:listing, on_delete: :nothing))

      timestamps()
    end

    create(index(:listing_repository, [:repository_id]))
    create(index(:listing_repository, [:listing_id]))
  end
end
