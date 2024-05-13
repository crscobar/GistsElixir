defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view
  alias ElixirGist.Gists
  alias ElixirGistWeb.GistFormComponent

  def mount(%{"id" => id}, _session, socket) do
    IO.puts("\n\nINSPECTING SOCKET 1 GISTs")
    IO.inspect(socket)
    IO.inspect(socket.assigns.current_user)
    gist = Gists.get_gist!(id)

    {:ok, relative_time} = Timex.format(gist.updated_at, "{relative}", :relative)
    gist = Map.put(gist, :relative, relative_time)
    {:ok, assign(socket, gist: gist)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Gists.delete_gist(socket.assigns.current_user, id) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist successfully deleted")
        {:noreply, push_navigate(socket, to: ~p"/create")}
      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end

  def handle_event("save-gist", %{"gist_id" => id, "user_id" => user_id}, socket) do
    case Gists.create_saved_gist(socket.assigns.current_user, %{gist_id: id, user_id: user_id}) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist successfully saved")
        {:noreply, socket}
      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
