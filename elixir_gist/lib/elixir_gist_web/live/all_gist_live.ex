defmodule ElixirGistWeb.AllGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists

  def mount(_params, _session, socket) do
    user_gists = Gists.list_user_gists(socket.assigns.current_user)

    {:ok, assign(socket, user_gists: user_gists)}
  end

  def handle_event("redirect", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end
end
