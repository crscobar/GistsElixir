defmodule ElixirGist.Gists.SavedGist do
  use ElixirGistWeb, :live_view
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "saved_gists" do

    belongs_to :user, ElixirGist.Accounts.User
    belongs_to :gist, ElixirGist.Gists.Gist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(saved_gist, attrs) do
    saved_gist
    |> cast(attrs, [:user_id, :gist_id])
    |> validate_required([:user_id, :gist_id])
    |> unsafe_validate_unique(:gist_id, ElixirGist.Repo)
  end
end
