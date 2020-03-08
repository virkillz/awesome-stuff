defmodule AwesomeGithub.Repo.Migrations.CreateListing do
  use Ecto.Migration

  def change do
    create table(:listing) do
      add :name, :string
      add :description, :text
      add :is_active, :boolean, default: false, null: false
      add :parent_id, references(:listing, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:listing, [:parent_id])
    create index(:listing, [:user_id])
  end
end
