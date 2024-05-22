defmodule ElixirGistWeb.AllGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  import ElixirGist.Helpers

  # TODO: Add pagination for all gists
  def mount(params, _session, socket) do
    IO.puts("all gists111111")
    IO.inspect(params)
    IO.puts(params["page"])

    all_gists = Gists.list_gists(params["page"])
    IO.puts("all gists?????")

    {:ok, assign(socket, all_gists: all_gists)}
  end

  def handle_event("go-to-gist", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist/all?page=#{page}")}
  end
end
