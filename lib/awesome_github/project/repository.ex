defmodule AwesomeGithub.Project.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field(:archieved, :boolean, default: false)
    field(:creator, :string)
    field(:custom_description, :string)
    field(:fork_count, :integer)
    field(:git_url, :string)
    field(:html_url, :string)
    field(:language, :string)
    field(:last_commit, :naive_datetime)
    field(:last_update, :naive_datetime)
    field(:license, :string)
    field(:license_url, :string)
    field(:long_description, :string)
    field(:open_issues_count, :integer)
    field(:repo_created_date, :naive_datetime)
    field(:repo_fullname, :string)
    field(:repo_name, :string)
    field(:short_description, :string)
    field(:star_count, :integer)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [
      :creator,
      :html_url,
      :git_url,
      :repo_name,
      :repo_fullname,
      :short_description,
      :long_description,
      :custom_description,
      :star_count,
      :fork_count,
      :last_commit,
      :license,
      :license_url,
      :open_issues_count,
      :archieved,
      :language,
      :last_update,
      :repo_created_date,
      :user_id
    ])
    |> validate_required([:repo_fullname])
    |> unique_constraint(:repo_fullname)
    |> validate_repo
  end

  def validate_repo(changeset) do
    repo = get_field(changeset, :repo_fullname)

    case Github.get(repo) do
      {:ok, repo_result} ->
        map_to_attr(changeset, repo_result)

      {:error, reason} ->
        add_error(changeset, :repo_fullname, reason)

      other ->
        IO.inspect(other)

        add_error(
          changeset,
          :repo_fullname,
          "Unknown Error. Find out in AwesomeGithub.Project.Repository module"
        )
    end
  end

  defp map_to_attr(changeset, repo_result) do
    changeset
    |> change(creator: repo_result["owner"]["login"])
    |> change(html_url: repo_result["html_url"])
    |> change(git_url: repo_result["git_url"])
    |> change(short_description: repo_result["description"])
    |> change(star_count: repo_result["stargazers_count"])
    |> change(fork_count: repo_result["fork_count"])
    |> change(repo_name: repo_result["name"])
    |> change(last_commit: repo_result["pushed_at"] |> naive_datetime_converter)
    |> change(last_update: repo_result["updated_at"] |> naive_datetime_converter)
    |> change(repo_created_date: repo_result["created_at"] |> naive_datetime_converter)
    |> change(archieved: repo_result["archived"])
    |> change(language: repo_result["language"])
    |> change(open_issues_count: repo_result["open_issues_count"])
    |> change(license: repo_result["license"]["name"])
    |> change(license_url: repo_result["license"]["url"])
    |> IO.inspect()
  end

  defp naive_datetime_converter(datetime_string) do
    case NaiveDateTime.from_iso8601(datetime_string) do
      {:ok, naive_datetime} -> naive_datetime
      _ -> nil
    end
  end
end
