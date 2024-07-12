defmodule ElixirGist.Gists do
  @moduledoc """
  The Gists context.
  """
  require Logger

  import Ecto.Query, warn: false
  alias ElixirGist.Gists
  alias ElixirGist.Repo

  alias ElixirGist.Gists.Gist
  alias ElixirGist.Accounts.User

  @doc """
  Returns the list of gists.

  ## Examples

      iex> list_gists()
      [%Gist{}, ...]

  """
  def list_gists(page) do
    gists =
      Gist
      |> ElixirGist.Repo.paginate(page: page, page_size: 10)
    gists
  end


  @doc """
  Returns a list of all gists user has created.

  ## Examples

      iex> list_user_gists()
      [%Gist{}, ...]

  """
  def list_user_gists(%User{} = user, page) do
    user_gists =
      Gist
      |> where([g], g.user_id == ^user.id)
      |> Repo.paginate(page: page, page_size: 10)
    user_gists
  end

  @doc """
  Gets a single gist.

  Raises `Ecto.NoResultsError` if the Gist does not exist.

  ## Examples

      iex> get_gist!(123)
      %Gist{}

      iex> get_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gist!(id), do: Repo.get!(Gist, id)

  @doc """
  Creates a gist.

  ## Examples

      iex> create_gist(%{field: value})
      {:ok, %Gist{}}

      iex> create_gist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gist(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:gists)
    |> Gist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gist.

  ## Examples

      iex> update_gist(gist, %{field: new_value})
      {:ok, %Gist{}}

      iex> update_gist(gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gist(%User{} = user, attrs) do
    gist = Repo.get!(Gist, attrs["id"])

    if user.id == gist.user_id do
      gist
      |> Gist.changeset(attrs)
      |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a gist.

  ## Examples

      iex> delete_gist(gist)
      {:ok, %Gist{}}

      iex> delete_gist(gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gist(%User{} = user, gist_id) do
    gist = Repo.get(Gist, gist_id)

    if user.id == gist.user_id do
      Repo.delete(gist)
      {:ok, gist}
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gist changes.

  ## Examples

      iex> change_gist(gist)
      %Ecto.Changeset{data: %Gist{}}

  """
  def change_gist(%Gist{} = gist, attrs \\ %{}) do
    Gist.changeset(gist, attrs)
  end

  alias ElixirGist.Gists.SavedGist

  @doc """
  Returns the list of saved_gists.

  ## Examples

      iex> list_all_saved_gists()
      [%SavedGist{}, ...]

  """
  def list_all_saved_gists do
    Repo.all(SavedGist)
  end

  @doc """
  Returns a list of all gists user has created.

  ## Examples

      iex> list_user_saved_gists()
      [%Gist{}, ...]

  """
  def list_user_saved_gists(%User{} = user, page) do
    saved_gist_ids =
      SavedGist
      |> where([g], g.user_id == ^user.id)
      |> preload([:gist])
      |> Repo.paginate(page: page, page_size: 10)
    saved_gist_ids
  end

  @doc """
  Returns a list of all gists containing search term in title or text.

  ## Examples

      iex> search_gists_for_term()
      [%Gist{}, ...]

  """
  def search_gists_for_term(search_term, page) do
    matching_gists =
      Gist
      |> where([g], ilike(g.name, ^"%#{search_term}%") or ilike(g.markup_text, ^"%#{search_term}%"))
      |> Repo.paginate(page: page, page_size: 10)
    IO.puts("SEARCHING FOR GISTS")
    IO.inspect(matching_gists)
    matching_gists
  end

  @doc """
  Gets a single saved_gist.

  Raises `Ecto.NoResultsError` if the Saved gist does not exist.

  ## Examples

      iex> get_saved_gist!(123)
      %SavedGist{}

      iex> get_saved_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_saved_gist!(gist_id), do: Repo.get_by(SavedGist, gist_id: gist_id)

  @doc """
  Gets a single saved_gist.

  Raises `Ecto.NoResultsError` if the Saved gist does not exist.

  ## Examples

      iex> get_saved_gist!(123)
      %SavedGist{}

      iex> get_saved_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_saved_gist(gist_id, user_id) do
    gist = Repo.one(from sg in SavedGist, where: sg.gist_id == ^gist_id and sg.user_id == ^user_id)
    gist
  end

  @doc """
  Creates a saved_gist.

  ## Examples

      iex> create_saved_gist(%{field: value})
      {:ok, %SavedGist{}}

      iex> create_saved_gist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_saved_gist(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:saved_gists)
    |> SavedGist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a saved_gist.

  ## Examples

      iex> update_saved_gist(saved_gist, %{field: new_value})
      {:ok, %SavedGist{}}

      iex> update_saved_gist(saved_gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_saved_gist(%SavedGist{} = saved_gist, attrs) do
    saved_gist
    |> SavedGist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a saved_gist.

  ## Examples

      iex> delete_saved_gist(saved_gist)
      {:ok, %SavedGist{}}

      iex> delete_saved_gist(saved_gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_saved_gist(attrs) do
    gist = Gists.get_saved_gist!(attrs.gist_id)
    gist
    |> Repo.delete()
  end

  @doc """
  Deletes a saved_gist for given user_id.

  ## Examples

      iex> delete_saved_gist(saved_gist)
      {:ok, %SavedGist{}}

      iex> delete_saved_gist(saved_gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_saved_gist(attrs) do
    sg = Gists.get_user_saved_gist(attrs.gist_id, attrs.user_id)
    sg
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saved_gist changes.

  ## Examples

      iex> change_saved_gist(saved_gist)
      %Ecto.Changeset{data: %SavedGist{}}

  """
  def change_saved_gist(%SavedGist{} = saved_gist, attrs \\ %{}) do
    SavedGist.changeset(saved_gist, attrs)
  end
end
