defmodule ElixirGistWeb.SavedGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  import ElixirGist.Helpers

  def mount(_params, _session, socket) do
    user_saved_gists = Gists.list_user_saved_gists(socket.assigns.current_user)

    {:ok, assign(socket, user_saved_gists: user_saved_gists)}
  end

  def handle_event("go-to-gist", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end
end
