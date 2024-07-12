defmodule ElixirGistWeb.SearchGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  import ElixirGist.Helpers

  def mount(params, _session, socket) do
    IO.puts("PARME")
    IO.inspect(params)
    socket = assign(socket, search_term: params["search_term"])
    search_result_gists = Gists.search_gists_for_term(params["search_term"], params["page"])

    {:ok, assign(socket, searched_gists: search_result_gists)}
  end

  def handle_event("search", %{"query" => search_term, "page" => page}, socket) do
    IO.puts("HANDLE SEARCG")
    {:noreply, push_navigate(socket, to: ~p"/gist/search?search_term=#{search_term}&page=#{page}")}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist/search?search_term=#{socket.assigns.search_term}&page=#{page}")}
  end
end
