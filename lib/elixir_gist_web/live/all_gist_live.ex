defmodule ElixirGistWeb.AllGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists

  # TODO: Add pagination for all gists
  def mount(_params, _session, socket) do
    all_gists = Gists.list_gists()

    {:ok, assign(socket, all_gists: all_gists)}
  end

  def handle_event("go-to-gist", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end
end
