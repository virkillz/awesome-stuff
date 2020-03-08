defmodule AwesomeGithubWeb.RepositoryControllerTest do
  use AwesomeGithubWeb.ConnCase

  alias AwesomeGithub.Project

  @create_attrs %{archieved: true, creator: "some creator", custom_description: "some custom_description", fork_count: 42, git_url: "some git_url", html_url: "some html_url", language: "some language", last_commit: ~N[2010-04-17 14:00:00], last_update: ~N[2010-04-17 14:00:00], license: "some license", license_url: "some license_url", long_description: "some long_description", open_issues_count: 42, repo_created_date: ~N[2010-04-17 14:00:00], repo_fullname: "some repo_fullname", repo_name: "some repo_name", short_description: "some short_description", star_count: 42}
  @update_attrs %{archieved: false, creator: "some updated creator", custom_description: "some updated custom_description", fork_count: 43, git_url: "some updated git_url", html_url: "some updated html_url", language: "some updated language", last_commit: ~N[2011-05-18 15:01:01], last_update: ~N[2011-05-18 15:01:01], license: "some updated license", license_url: "some updated license_url", long_description: "some updated long_description", open_issues_count: 43, repo_created_date: ~N[2011-05-18 15:01:01], repo_fullname: "some updated repo_fullname", repo_name: "some updated repo_name", short_description: "some updated short_description", star_count: 43}
  @invalid_attrs %{archieved: nil, creator: nil, custom_description: nil, fork_count: nil, git_url: nil, html_url: nil, language: nil, last_commit: nil, last_update: nil, license: nil, license_url: nil, long_description: nil, open_issues_count: nil, repo_created_date: nil, repo_fullname: nil, repo_name: nil, short_description: nil, star_count: nil}

  def fixture(:repository) do
    {:ok, repository} = Project.create_repository(@create_attrs)
    repository
  end

  describe "index" do
    test "lists all repositories", %{conn: conn} do
      conn = get conn, repository_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Repositories"
    end
  end

  describe "new repository" do
    test "renders form", %{conn: conn} do
      conn = get conn, repository_path(conn, :new)
      assert html_response(conn, 200) =~ "New Repository"
    end
  end

  describe "create repository" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, repository_path(conn, :create), repository: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == repository_path(conn, :show, id)

      conn = get conn, repository_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Repository"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, repository_path(conn, :create), repository: @invalid_attrs
      assert html_response(conn, 200) =~ "New Repository"
    end
  end

  describe "edit repository" do
    setup [:create_repository]

    test "renders form for editing chosen repository", %{conn: conn, repository: repository} do
      conn = get conn, repository_path(conn, :edit, repository)
      assert html_response(conn, 200) =~ "Edit Repository"
    end
  end

  describe "update repository" do
    setup [:create_repository]

    test "redirects when data is valid", %{conn: conn, repository: repository} do
      conn = put conn, repository_path(conn, :update, repository), repository: @update_attrs
      assert redirected_to(conn) == repository_path(conn, :show, repository)

      conn = get conn, repository_path(conn, :show, repository)
      assert html_response(conn, 200) =~ "some updated creator"
    end

    test "renders errors when data is invalid", %{conn: conn, repository: repository} do
      conn = put conn, repository_path(conn, :update, repository), repository: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Repository"
    end
  end

  describe "delete repository" do
    setup [:create_repository]

    test "deletes chosen repository", %{conn: conn, repository: repository} do
      conn = delete conn, repository_path(conn, :delete, repository)
      assert redirected_to(conn) == repository_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, repository_path(conn, :show, repository)
      end
    end
  end

  defp create_repository(_) do
    repository = fixture(:repository)
    {:ok, repository: repository}
  end
end
