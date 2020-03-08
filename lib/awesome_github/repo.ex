defmodule AwesomeGithub.Repo do
  use Ecto.Repo,
    otp_app: :awesome_github,
    adapter: Ecto.Adapters.Postgres
end
