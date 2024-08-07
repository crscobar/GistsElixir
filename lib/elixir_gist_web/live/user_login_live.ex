defmodule ElixirGistWeb.UserLoginLive do
  use ElixirGistWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="gist-gradient flex flex-col items-center justify-center pt-24">
      <h1 class="font-brand font-bold text-3xl text-white py-2">
        Sign in to account
      </h1>
      <h3 class="font-brand font-bold text-l text-white">
        Don't have an account?
        <.link
          navigate={~p"/users/register"}
          class="font-semibold text-brand hover:underline text-emLavender-dark text-gistPurp hover:text-gistPurp-light transition"
        >
          Register
        </.link>
        for an account now.
      </h3>
    </div>
    <div class="mx-auto max-w-sm pt-10">
      <.form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <.input field={@form[:password]} type="password" placeholder="Password" required />
        <div class="flex item-scenter justify-between py-4">
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link
            href={~p"/users/reset_password"}
            class="text-m text_brand text-gistPurp hover:text-gistPurp-light transition font-semibold hover:underline"
          >
            Forgot your password?
          </.link>
        </div>
        <.button phx-disable-with="Signing in..." class="gist-button w-full">
          Sign in <span aria-hidden="true">→</span>
        </.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
