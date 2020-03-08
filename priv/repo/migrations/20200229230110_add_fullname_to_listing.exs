defmodule AwesomeGithub.Repo.Migrations.AddFullnameToListing do
  use Ecto.Migration

  def change do
    alter table(:listing) do
      add(:fullname, :string)
    end
  end
end
