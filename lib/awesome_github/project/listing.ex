defmodule AwesomeGithub.Project.Listing do
  use Ecto.Schema
  import Ecto.Changeset

  alias AwesomeGithub.Project

  schema "listing" do
    field(:description, :string)
    field(:is_active, :boolean, default: true)
    field(:name, :string)
    field(:fullname, :string)
    field(:user_id, :id)

    timestamps()

    belongs_to(:parent, AwesomeGithub.Project.Listing)
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [:name, :fullname, :parent_id, :description, :is_active])
    |> validate_required([:name])
    |> add_fullname
  end

  def add_fullname(changeset) do
    parent_id = get_field(changeset, :parent_id)
    name = get_field(changeset, :name)

    if is_nil(parent_id) do
      change(changeset, fullname: name)
    else
      parent_data = Project.get_listing!(parent_id)
      change(changeset, fullname: "#{parent_data.fullname}/#{name}")
    end
  end
end
