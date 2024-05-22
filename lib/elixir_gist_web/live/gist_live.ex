defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view
  alias ElixirGist.Gists
  alias ElixirGistWeb.GistFormComponent

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    {:ok, relative_time} = Timex.format(gist.updated_at, "{relative}", :relative)
    gist = Map.put(gist, :relative, relative_time)

    {:ok,
      socket
      |> push_event("Highlight", %{name: gist.name})
      |> assign(gist: gist)
    }
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

  def handle_event("save-gist", %{"gist_id" => gist_id, "user_id" => user_id}, socket) do
    case Gists.create_saved_gist(socket.assigns.current_user, %{gist_id: gist_id, user_id: user_id}) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist successfully saved")
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
      {:error, String = message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
      {:error, %Ecto.Changeset{} = changeset} ->
        error_msg = "#{(List.first(changeset.errors)) |> elem(0)} #{(List.first(changeset.errors)) |> elem(1) |> elem(0)}"

        socket = put_flash(socket, :error, error_msg)
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
    end
  end

  def handle_event("unsave-gist", %{"gist_id" => gist_id}, socket) do
    case Gists.delete_saved_gist(%{gist_id: gist_id}) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist successfully unsaved")
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}

      {:error, String = message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
      {:error, %Ecto.Changeset{} = changeset} ->
        error_msg = "#{(List.first(changeset.errors)) |> elem(0)} #{(List.first(changeset.errors)) |> elem(1) |> elem(0)}"

        socket = put_flash(socket, :error, error_msg)
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
    end
  end

  def handle_event("cancel", %{"gist_id" => gist_id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
  end

  def handle_info("show_end", socket) do
    IO.puts('show end')
    {:noreply, socket}
  end

  def toggle_copied_popup do
    JS.show(
      to: "#copied_popup",
      transition: {"transition ease-out duration-500", "transform opacity-0", "transform opacity-100"},
      time: 500
    )
  end

  def toggle_copied_popdown do
    JS.hide(
      to: "#copied_popup",
      transition: {"transition ease-in duartion-350", "transform opacity-100", "transform opacity-0"},
      time: 500
    )
  end
end
