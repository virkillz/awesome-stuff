defmodule AwesomeGithub.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :creator, :string
      add :html_url, :string
      add :git_url, :string
      add :repo_name, :string
      add :repo_fullname, :string
      add :short_description, :text
      add :long_description, :text
      add :custom_description, :text
      add :star_count, :integer
      add :fork_count, :integer
      add :last_commit, :naive_datetime
      add :license, :string
      add :license_url, :string
      add :open_issues_count, :integer
      add :archieved, :boolean, default: false, null: false
      add :language, :string
      add :last_update, :naive_datetime
      add :repo_created_date, :naive_datetime
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:repositories, [:user_id])
  end
end
