defmodule AwesomeGithubWeb.PageController do
  use AwesomeGithubWeb, :controller

  alias AwesomeGithub.Account
  alias AwesomeGithub.Account.User
  alias AwesomeGithub.Project

  def index(conn, _params) do
    repos = Project.list_listing_repository()

    list =
      Enum.uniq_by(repos, fn %AwesomeGithub.Project.ListingRepository{listing_id: x} -> x end)

    conn
    |> render("index.html",
      layout: {AwesomeGithubWeb.LayoutView, "fe.html"},
      repos: repos,
      list: list
    )
  end

  def login(conn, _params) do
    changeset = Account.change_user(%User{})

    render(conn, "login.html",
      layout: {AwesomeGithubWeb.LayoutView, "fe.html"},
      changeset: changeset
    )
  end

  def lgn(conn, _params) do
    changeset = Account.change_user(%User{})

    render(conn, "login-nosocial.html",
      layout: {AwesomeGithubWeb.LayoutView, "fe.html"},
      changeset: changeset
    )
  end

  def register(conn, _params) do
    changeset = Account.change_user(%User{})

    render(conn, "register.html",
      layout: {AwesomeGithubWeb.LayoutView, "fe.html"},
      changeset: changeset
    )
  end

  def createuser(conn, %{"user" => params}) do
    case Account.create_user_frontend(params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully. You can login now")
        |> redirect(to: "/lgn")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        conn
        |> put_flash(:error, "Oops, check error below")
        |> render("register.html",
          layout: {AwesomeGithubWeb.LayoutView, "fe.html"},
          changeset: changeset
        )
    end
  end

  def auth(conn, %{"email" => email, "password" => password}) do
    case Account.authenticate_user_front(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: "/")

      {:error, reason} ->
        changeset = Account.change_user(%User{})

        conn
        |> put_flash(:error, reason)
        |> render("login-nosocial.html",
          layout: {AwesomeGithubWeb.LayoutView, "fe.html"},
          changeset: changeset
        )
    end
  end

  def recover(conn, _params) do
    render(conn, "recover.html", layout: {AwesomeGithubWeb.LayoutView, "fe.html"})
  end

  def signout(conn, _parms) do
    conn
    |> Plug.Conn.configure_session(drop: true)
    |> redirect(to: "/")
  end
end
