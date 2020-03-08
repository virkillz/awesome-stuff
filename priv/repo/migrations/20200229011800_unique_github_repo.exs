defmodule AwesomeGithub.Repo.Migrations.UniqueGithubRepo do
  use Ecto.Migration

  def change do
    create(unique_index(:repositories, [:repo_fullname]))
  end
end
