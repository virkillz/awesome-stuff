defmodule Github do
  @base_url "https://api.github.com/repos/"

  def get(repo_name) do
    case HTTPoison.get("#{@base_url}#{repo_name}") do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode(body) |> IO.inspect()

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Repo not founded"}

      other ->
        IO.inspect(other)
        {:error, "Cannot connect to Github API"}
    end
  end
end
