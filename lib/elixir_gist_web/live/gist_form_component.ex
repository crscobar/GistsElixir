defmodule ElixirGistWeb.GistFormComponent do
  use ElixirGistWeb, :live_component
  use PhoenixHTMLHelpers

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center pt-6 px-2">
      <.form
        for={@form}
        phx-submit="create"
        phx-change="validate"
        phx-target={@myself}
        class="w-full max-w-[70rem] justify-center"
      >
        <div class="px-4 w-full space-y-4 mb-10">
          <%= hidden_input(@form, :id, value: @id) %>
          <.input
            field={@form[:description]}
            placeholder="Gist description.."
            autocomplete="off"
            phx-debounce="blur"
            class="bg-gistDark-light"
          />
          <div>
            <div class="flex bg-gistDark-light rounded-t-md border">
              <div class="w-[300px] mb-2 ml-2">
                <.input
                  field={@form[:name]}
                  placeholder="Filename with extension..."
                  autocomplete="off"
                  phx-debounce="blur"
                />
              </div>
            </div>
            <div id="gist-form-wrapper" class="flex w-full" phx-update="ignore">
              <textarea id="line-numbers" class="line-numbers rounded-bl-md" readonly>
                <%= "1\n" %>
              </textarea>
              <%= textarea(@form, :markup_text,
                id: "gist-textarea",
                phx_hook: "UpdateLineNumbers",
                class: "textarea w-full rounded-br-md h-96",
                placeholder: "Insert code...",
                spellcheck: "false",
                autocomplete: "off",
                phx_debounce: "blur"
              ) %>
            </div>
          </div>
          <%= if @current_user do %>
            <div class="flex flex-row justify-end">
              <%= if @id == :new do %>
                <div class="flex justify-end">
                  <.button class="gist-button" phx-disable-with="Creating...">Create gist</.button>
                </div>
              <% else %>
                <div class="flex-row justify-end mr-4">
                  <.button class="gist-button" type="button" phx-click="cancel" phx-value-gist_id={@id}>Cancel</.button>
                </div>
                <div class="flex-row justify-end">
                  <.button class="gist-button" phx-disable-with="Updating...">Update</.button>
                </div>
              <% end %>
            </div>
          <% else %>
            <div class="flex justify-end">
              <a
                class="gist-button-href"
                href={~p"/users/log_in"}
              >
                Log In To Create Gists
              </a>
            </div>
          <% end %>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    if params["id"] == "new" do
      create_gist(params, socket)
    else
      update_gist(params, socket)
    end
  end

  def handle_event("login_redirect", _, socket) do
    {:noreply, push_navigate(socket, to: ~p"/users/log_in")}
  end

  defp create_gist(params, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_gist(params, socket) do
    case Gists.update_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
