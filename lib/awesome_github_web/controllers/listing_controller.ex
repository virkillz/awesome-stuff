defmodule AwesomeGithubWeb.ListingController do
  use AwesomeGithubWeb, :controller

  alias AwesomeGithub.Project
  alias AwesomeGithub.Project.Listing

  def index(conn, _params) do
    listing = Project.list_listing() |> IO.inspect()
    render(conn, "index.html", listing: listing)
  end

  def new(conn, _params) do
    changeset = Project.change_listing(%Listing{})
    list = Project.list_listing() |> Enum.map(fn x -> {x.name, x.id} end)
    render(conn, "new.html", changeset: changeset, list: list)
  end

  def create(conn, %{"listing" => listing_params}) do
    case Project.create_listing(listing_params) do
      {:ok, listing} ->
        conn
        |> put_flash(:info, "Listing created successfully.")
        |> redirect(to: listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    listing = Project.get_listing!(id)
    render(conn, "show.html", listing: listing)
  end

  def delete(conn, %{"id" => id}) do
    listing = Project.get_listing!(id)
    {:ok, _listing} = Project.delete_listing(listing)

    conn
    |> put_flash(:info, "Listing deleted successfully.")
    |> redirect(to: listing_path(conn, :index))
  end
end
