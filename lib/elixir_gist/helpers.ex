defmodule ElixirGist.Helpers do
  import Ecto.Query, warn: false

  alias ElixirGist.Accounts.User
  alias ElixirGist.Repo

  def get_relative_time(gist) do
    relative_time = Timex.format(gist.updated_at, "{relative}", :relative)
    relative_time
  end

  def get_username_from_user_id(user_id) do
    username = Repo.one(from u in User, where: u.id == ^user_id, select: u.username)
    username
  end
end
