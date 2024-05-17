defmodule ElixirGistWeb.AllGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists

  # TODO: Add pagination for all gists
  def mount(_params, _session, socket) do
    all_gists = Gists.list_gists()
    IO.inspect(all_gists)

    # for gist <- all_gists do
    #   {:ok, relative_time} = Timex.format(gist.updated_at, "{relative}", :relative)
    #   IO.puts("RELATIVE TIME")
    #   gist = Map.put(gist, :relative, relative_time)
    # end

    # Enum.each all_gists, fn(gist) ->
    #   {:ok, relative_time} = Timex.format(gist.updated_at, "{relative}", :relative)
    #   IO.puts("\n\nGist before map")
    #   IO.inspect(gist)
    #   IO.puts("\n\nGist after map")
    #   IO.inspect(Map.put(gist, :relative, relative_time))
    #   IO.puts("RELATIVE TIME")
    #   ^gist = Map.put(gist, :relative, relative_time)
    # end

    # IO.puts("ALL GIST AFTER")
    # IO.inspect((all_gists))
    {:ok, assign(socket, all_gists: all_gists)}
  end

  def handle_event("go-to-gist", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end

  def get_relative_time(gist) do
    relative_time = Timex.format(gist.updated_at, "{relative}", :relative)
    relative_time
  end
end
