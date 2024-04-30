defmodule ElixirGistWeb.AllGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGistWeb.GistFormComponent

  def mount(_params, _session, socket) do
    # IO.puts("\n\n\n\nSOCKET HERE\n\n\n\n")
    user_gists = Gists.list_user_gists(socket.assigns.current_user)

    {:ok, assign(socket, user_gists: user_gists)}
  end
end
