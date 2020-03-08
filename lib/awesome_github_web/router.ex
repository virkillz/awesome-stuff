defmodule AwesomeGithubWeb.Router do
  use AwesomeGithubWeb, :router

  # -----------------pipeline ----------------

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(AwesomeGithubWeb.Plugs.SetCurrentUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(AwesomeGithub.Auth.AuthAccessPipeline)
  end

  # ----------------- scope route ----------------

  scope "/admin", AwesomeGithubWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", UserController, :dashboard)
    get("/profile", UserController, :profile)
    get("/locked", UserController, :locked)
    resources("/activity", ActivityController, only: [:index, :show, :delete])
    resources("/user", UserController)
    get("/logout", UserController, :logout)

    resources("/repositories", RepositoryController)
    resources("/listing", ListingController, except: [:edit, :update])
    resources("/listing_repository", ListingRepositoryController)
  end

  scope "/", AwesomeGithubWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/login", PageController, :login)
    get("/lgn", PageController, :lgn)
    get("/register", PageController, :register)
    post("/login", PageController, :auth)
    post("/register", PageController, :createuser)
    get("/recover", PageController, :recover)
    get("/admin/login", UserController, :login)
    post("/admin/login", UserController, :auth)
    get("/signout", PageController, :signout)
  end

  # Other scopes may use custom stacks.
  # scope "/api", AwesomeGithubWeb do
  #   pipe_through :api
  # end
end
