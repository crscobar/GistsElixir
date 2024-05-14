defmodule ElixirGistWeb.AllGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists

  # TODO: Add pagination for all gists
  def mount(_params, session, socket) do
    IO.puts("\n\nINSPECTING SOCKET ALL GISTs")
    IO.inspect(socket)
    IO.inspect(socket.assigns.current_user)
    IO.inspect(session)
    IO.puts(Map.has_key?(session, :user_token))
    if(Map.has_key?(session, "user_token") == false) do
      IO.puts("IN IF MATCH!!!\n\n")
    end
    all_gists = Gists.list_gists()

    {:ok, assign(socket, all_gists: all_gists)}
  end

  def handle_event("redirect", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{id}")}
  end
end
