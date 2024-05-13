defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.{Gists.Gist, Gists}
  alias ElixirGist.Accounts.User
  alias ElixirGistWeb.GistFormComponent

  def mount(_params, _session, socket) do
    IO.puts("\n\nINSPECTING SOCKET")
    IO.inspect(socket)
    IO.inspect(socket.assigns, printable_limit: :infinity)
    if(match?(%User{}, socket.assigns) == false) do
      IO.puts("IN IF MATCH!!!\n\n")
      socket =
        socket
        |> assign_new(:current_user, fn -> nil end)
      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="gist-gradient flex items-center justify-center">
      <h1 class="font-brand font-bold text-3xl text-white">
        Instantly share Elixir code, notes, and snippets.
      </h1>
    </div>

    <.live_component
      module={GistFormComponent}
      id={:new}
      current_user={@current_user}
      form={to_form(Gists.change_gist(%Gist{}))}
    />
    """
  end
end
