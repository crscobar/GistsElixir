defmodule ElixirGistWeb.YourGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  import ElixirGist.Helpers

  # TODO: when no gists, display text "No gists created yet :("
  def mount(params, _session, socket) do
    user_gists = Gists.list_user_gists(socket.assigns.current_user, params["page"])

    {:ok, assign(socket, user_gists: user_gists)}
  end

  def handle_event("redirect", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist/yours?page=#{page}")}
  end
end
