defmodule ElixirGistWeb.SearchGistLive do
  use ElixirGistWeb, :live_view

  import ElixirGist.Gists
  import ElixirGist.Helpers

  def mount(%{"search_term" => %{"query" => search_term}} = _params, _, socket) do
    {:ok, assign(socket, search_term: search_term)}
  end

  def handle_event("search", %{"query" => search_term, "page" => page}, socket) do
    IO.puts("HANDLE SEARCG")
    {:noreply, push_navigate(socket, to: ~p"/gist/search?search_term=#{search_term}&page=#{page}")}
  end

end
