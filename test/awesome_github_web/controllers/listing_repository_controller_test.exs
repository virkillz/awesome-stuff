defmodule AwesomeGithubWeb.ListingRepositoryControllerTest do
  use AwesomeGithubWeb.ConnCase

  alias AwesomeGithub.Project

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:listing_repository) do
    {:ok, listing_repository} = Project.create_listing_repository(@create_attrs)
    listing_repository
  end

  describe "index" do
    test "lists all listing_repository", %{conn: conn} do
      conn = get conn, listing_repository_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Listing repository"
    end
  end

  describe "new listing_repository" do
    test "renders form", %{conn: conn} do
      conn = get conn, listing_repository_path(conn, :new)
      assert html_response(conn, 200) =~ "New Listing repository"
    end
  end

  describe "create listing_repository" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, listing_repository_path(conn, :create), listing_repository: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == listing_repository_path(conn, :show, id)

      conn = get conn, listing_repository_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Listing repository"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, listing_repository_path(conn, :create), listing_repository: @invalid_attrs
      assert html_response(conn, 200) =~ "New Listing repository"
    end
  end

  describe "edit listing_repository" do
    setup [:create_listing_repository]

    test "renders form for editing chosen listing_repository", %{conn: conn, listing_repository: listing_repository} do
      conn = get conn, listing_repository_path(conn, :edit, listing_repository)
      assert html_response(conn, 200) =~ "Edit Listing repository"
    end
  end

  describe "update listing_repository" do
    setup [:create_listing_repository]

    test "redirects when data is valid", %{conn: conn, listing_repository: listing_repository} do
      conn = put conn, listing_repository_path(conn, :update, listing_repository), listing_repository: @update_attrs
      assert redirected_to(conn) == listing_repository_path(conn, :show, listing_repository)

      conn = get conn, listing_repository_path(conn, :show, listing_repository)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, listing_repository: listing_repository} do
      conn = put conn, listing_repository_path(conn, :update, listing_repository), listing_repository: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Listing repository"
    end
  end

  describe "delete listing_repository" do
    setup [:create_listing_repository]

    test "deletes chosen listing_repository", %{conn: conn, listing_repository: listing_repository} do
      conn = delete conn, listing_repository_path(conn, :delete, listing_repository)
      assert redirected_to(conn) == listing_repository_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, listing_repository_path(conn, :show, listing_repository)
      end
    end
  end

  defp create_listing_repository(_) do
    listing_repository = fixture(:listing_repository)
    {:ok, listing_repository: listing_repository}
  end
end
