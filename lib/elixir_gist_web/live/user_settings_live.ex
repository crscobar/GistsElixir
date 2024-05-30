defmodule ElixirGistWeb.UserSettingsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Accounts

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)
    username_changeset = Accounts.change_user_username(user)
    profile_image_changset = Accounts.change_profile_image(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:username_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:current_username, user.username)
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:username_form, to_form(username_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:image_form, to_form(profile_image_changset))
      |> assign(:image_error, false)
      |> assign(:profile_image, user.profile_image)
      |> assign(:resized_image_src, false)
      |> assign(:allow_image_upload, false)


    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="gist-gradient flex flex-col items-center justify-center pt-24">
      <h1 class="font-brand font-bold text-3xl text-white py-2">
        Account Settings
      </h1>
      <h3 class="font-brand font-bold text-l text-white">
        Manage your account email address and password settings
      </h3>
    </div>
    <div class="flex flex-row flex-wrap w-full justify-center">
      <div id="email-form-container" class="settings-form-container">
        <div id="email-form" class="settings-form">
          <p class="font-brand font-bold text-xl text-gistPurp-light">Change Email</p>
          <.form for={@email_form} id="email_form" phx-submit="update_email" phx-change="validate_email" class="relative h-[95%]">
            <.input field={@email_form[:email]} type="email" placeholder="Email" required />
            <.input
              field={@email_form[:current_password]}
              name="current_password"
              id="current_password_for_email"
              type="password"
              placeholder="Current password"
              value={@email_form_current_password}
              required
            />
            <div class="absolute inset-x-0 bottom-7">
              <.button phx-disable-with="Changing..." class="gist-button">Change Email</.button>
            </div>
          </.form>
        </div>
      </div>

      <div id="password-form-container" class="settings-form-container">
        <div id="password-form" class="settings-form">
          <p class="font-brand font-bold text-xl text-gistPurp-light">Change Password</p>
          <.form
            for={@password_form}
            id="password_form"
            action={~p"/users/log_in?_action=password_updated"}
            method="post"
            phx-change="validate_password"
            phx-submit="update_password"
            phx-trigger-action={@trigger_submit}
            class="relative h-[95%]"
          >
            <.input
              field={@password_form[:email]}
              type="hidden"
              id="hidden_user_email"
              value={@current_email}
            />
            <.input
              field={@password_form[:current_password]}
              name="current_password"
              type="password"
              placeholder="Current password"
              id="current_password_for_password"
              value={@current_password}
              required
            />
            <.input
              field={@password_form[:password]}
              type="password"
              placeholder="New password"
              required
            />
            <.input
              field={@password_form[:password_confirmation]}
              type="password"
              placeholder="Confirm new password"
            />
            <div class="absolute inset-x-0 bottom-7">
              <.button phx-disable-with="Changing..." class="gist-button">Change Password</.button>
            </div>
          </.form>
        </div>
      </div>

      <div id="username-form-container" class="settings-form-container">
        <div id="username-form" class="settings-form">
          <p class="font-brand font-bold text-xl text-gistPurp-light">Change Username</p>
          <.form for={@username_form} id="username_form" phx-submit="update_username" phx-change="validate_username" class="relative h-[95%]">
            <.input field={@username_form[:username]} type="text" placeholder="Username" required />
            <.input
              field={@username_form[:current_password]}
              name="current_password"
              id="current_password_for_username"
              type="password"
              placeholder="Current password"
              value={@username_form_current_password}
              required
            />
            <div class="absolute inset-x-0 bottom-7">
              <.button phx-disable-with="Changing..." class="gist-button">Change Username</.button>
            </div>
          </.form>
        </div>
      </div>

      <div id="profile-image-form-container" class="settings-form-container">
        <div id="profile-image-form" class="settings-form">
          <div id="image-uploader-container" class="">
            <label>
            <p class="font-brand font-bold text-xl text-gistPurp-light">Change Profile Image</p>
              <input
                id="profile-image-uploader"
                type="file"
                accept="image/png, image/jpeg, image/jpg, image/webp"
                phx-hook="Resize"
                class="pt-2"
              />
            </label>

            <%= if @image_error do %>
              <p class="text-red-500"><%= @image_error %></p>
            <% end %>
          </div>

          <.simple_form
            for={@image_form}
            id="profile_image_form"
            phx-submit="update_profile_image"
            phx-change="validate_profile_image"
            class="bg-gistDark"
          >
            <div id="image-preview-container" class="pt-4 h-52 w-full bg-gistDark">
              <%= if @resized_image_src do %>
                <img class="object-scale-down h-52 w-52 mx-auto" src={@resized_image_src} alt="preview resized image" />
              <% end %>
            </div>

            <.input
              id="profile-image-src-input"
              field={@image_form[:profile_image]}
              type="hidden"
              value={@resized_image_src}
              required
            />

            <:actions>
              <div class="absolute inset-x-6 bottom-6">
                <%= if @allow_image_upload do %>
                  <.button phx-disable-with="Changing..." id="submit-image-btn" class="gist-button">
                    Change Profile Image
                  </.button>
                <% end %>
              </div>
            </:actions>
          </.simple_form>
        </div>
      </div>

    </div>
    """
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("validate_username", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    username_form =
      socket.assigns.current_user
      |> Accounts.change_user_username(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, username_form: username_form, username_form_current_password: password)}
  end

  def handle_event("update_username", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_username(user, password, user_params) do
      {:ok, user} ->
        username_form =
          user
          |> Accounts.change_user_username(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, username_form: username_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, username_form: to_form(changeset))}
    end
  end

  def handle_event("validate_profile_image", %{"user" => %{"profile_image" => profile_image}}, socket) do
    case ElixirGist.ImageValidator.validate_image(profile_image, 2 * 1024 * 1024, ~w(jpg jpeg gif png webp)) do
      {:ok, data_url} ->
        {:noreply,
         socket
         |> assign(resized_image_src: data_url, allow_image_upload: true, image_error: false)}

      {:error, message} ->
        {:noreply, socket |> assign(allow_image_upload: false, image_error: message)}
    end
  end

  def handle_event("update_profile_image", %{"user" => %{"profile_image" => profile_image}}, socket) do
    # Make sure that the image data is still valid
    case ElixirGist.ImageValidator.validate_image(
      profile_image,
      2 * 1024 * 1024,
      ~w(jpg jpeg gif png webp)
    ) do

      {:ok, data_url} ->
        handle_update_profile_image(data_url, socket)

      {:error, message} ->
        {:noreply, socket |> assign(allow_image_upload: false, image_error: message)}
    end
  end

  defp handle_update_profile_image(profile_image, socket) do
    [_meta_data, base64] = String.split(profile_image, ",")

    file_name = generate_file_name()

    image_binary = Base.decode64!(base64)

    cwd = (File.cwd |> elem(1))
    destination = Path.join([cwd, "priv", "static", "uploads", Path.basename(file_name)])

    File.write!(destination, image_binary)

    src_path = ~p"/uploads/#{Path.basename(destination)}"

    prev_file_name = socket.assigns.current_user.profile_image

    case Accounts.update_profile_image(socket.assigns.current_user, %{profile_image: src_path}) do
      {:ok, _} ->
        # If update was ok, then remove previous image
        case String.length(prev_file_name) > 0 do
          true ->
            previous_file_path =
              Path.join([
                cwd,
                "priv",
                "static",
                "uploads",
                Path.basename(prev_file_name)
              ])

            File.rm!(previous_file_path)
        end

        # Send back the updated image path and reset upload assignments
        {
          :noreply,
          socket
          |> assign(:profile_image, src_path)
          |> assign(:resized_image_src, false)
          |> assign(:allow_image_upload, false)
          |> put_flash(:info, "Successfully changed profile image!")
          |> push_redirect(to: ~p"/users/settings", replace: true)
        }

      {:error, _} ->
        {:noreply, socket |> assign(image_error: "Could not update new image to user.")}
    end
  end

  defp generate_file_name do
    # Get the current timestamp in milliseconds
    timestamp = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    # Generate a random string of 8 characters
    random_string = :crypto.strong_rand_bytes(8) |> Base.encode64(padding: false)

    # Concatenate the timestamp and the random string with a dash
    "#{timestamp}-#{random_string}"
  end
end
