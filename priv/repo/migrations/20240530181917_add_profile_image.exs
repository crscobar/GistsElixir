defmodule ElixirGist.Repo.Migrations.AddProfileImage do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_image, :string
    end
  end
end
