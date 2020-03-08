defmodule AwesomeGithubWeb.ListingRepositoryController do
  use AwesomeGithubWeb, :controller

  alias AwesomeGithub.Project
  alias AwesomeGithub.Project.ListingRepository

  def index(conn, _params) do
    listing_repository = Project.list_listing_repository() |> IO.inspect()
    render(conn, "index.html", listing_repository: listing_repository)
  end

  def new(conn, _params) do
    changeset = Project.change_listing_repository(%ListingRepository{})
    list = Project.list_listing() |> Enum.map(fn x -> {x.fullname, x.id} end)
    render(conn, "new.html", changeset: changeset, list: list)
  end

  def create(conn, %{"listing_repository" => listing_repository_params}) do
    case Project.create_listing_repository(listing_repository_params) do
      {:ok, listing_repository} ->
        conn
        |> put_flash(:info, "Listing repository created successfully.")
        |> redirect(to: listing_repository_path(conn, :show, listing_repository))

      {:error, %Ecto.Changeset{} = changeset} ->
        list = Project.list_listing() |> Enum.map(fn x -> {x.fullname, x.id} end)
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset, list: list)
    end
  end

  def show(conn, %{"id" => id}) do
    listing_repository = Project.get_listing_repository!(id)
    render(conn, "show.html", listing_repository: listing_repository)
  end

  def edit(conn, %{"id" => id}) do
    listing_repository = Project.get_listing_repository!(id)
    changeset = Project.change_listing_repository(listing_repository)
    render(conn, "edit.html", listing_repository: listing_repository, changeset: changeset)
  end

  def update(conn, %{"id" => id, "listing_repository" => listing_repository_params}) do
    listing_repository = Project.get_listing_repository!(id)

    case Project.update_listing_repository(listing_repository, listing_repository_params) do
      {:ok, listing_repository} ->
        conn
        |> put_flash(:info, "Listing repository updated successfully.")
        |> redirect(to: listing_repository_path(conn, :show, listing_repository))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", listing_repository: listing_repository, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    listing_repository = Project.get_listing_repository!(id)
    {:ok, _listing_repository} = Project.delete_listing_repository(listing_repository)

    conn
    |> put_flash(:info, "Listing repository deleted successfully.")
    |> redirect(to: listing_repository_path(conn, :index))
  end
end
