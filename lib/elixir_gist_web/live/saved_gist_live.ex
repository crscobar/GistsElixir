defmodule ElixirGistWeb.SavedGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  import ElixirGist.Helpers

  # TODO: when no gists, display text "No gists saved yet :("

  def mount(params, _session, socket) do
    user_saved_gists = Gists.list_user_saved_gists(socket.assigns.current_user, params["page"])

    {:ok, assign(socket, user_saved_gists: user_saved_gists)}
  end

  def handle_event("go-to-gist", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist/saved?page=#{page}")}
  end
end
