defmodule ElixirGistWeb.AboutLive do
  use ElixirGistWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="gist-gradient flex flex-col flex-grow items-center justify-center">
        <h1 class="font-brand font-bold text-white text-3xl text-center">About This Page</h1>
      </div>

      <div>
        <div id="paragraph-div" class="text-center mb-10">
          <h2 class="font-brand font-regular text-white text-xl text-center pt-12 pb-6">
            This page is written using the following languages and technologies:
          </h2>
          <section id="tech-list" class="flex-wrap justify-center block overflow-auto">
            <div id="container" class="flex flex-auto flex-wrap h-auto min-h-full justify-center items-center object-center p-2">

              <div class="border border-gistPurp-light max-w-[22rem] w-full h-48 rounded-lg shrink-0 m-4">
                <div id="elixir-box" class="bg-gistDark h-full w-full rounded-lg content-center space-y-1">
                  <img src="/images/gist-logo.svg" alt="Elixir Logo" class="w-auto h-8 mx-auto">
                  <p class="font-bold font-brand p-1">Elixir</p>
                  <p class="font-normal font-brand text-gray-300 px-2 pb-1">A dynamic, functional language for building scalable and maintainable apps.</p>
                  <div class="flex group items-center border border-none rounded-lg py-[0.2rem] px-[0.4rem] w-fit mx-auto bg-gistDark-light">
                    <a href="https://elixir-lang.org/" target="_blank" class="text-gistLav-dark group-hover:text-gistLav-light transition p-1">https://elixir-lang.org/</a>
                      <img src="/images/external-link.svg" alt="Elixir External Link" class="w-5 h-5 mx-auto  group-hover:text-gistLav-light group-hover:fill-gistLav-light group-hover:translate-x-[1px] group-hover:-translate-y-[2px] transition" />
                  </div>
                </div>
              </div>

              <div class="border border-gistPurp-light max-w-[22rem] w-full h-48 rounded-lg shrink-0 m-4">
                <div id="phoenix-box" class="bg-gistDark h-full w-full rounded-lg content-center space-y-1">
                  <img src="/images/phoenix.png" alt="Phoenix Logo" class="w-auto h-8 mx-auto">
                  <p class="font-bold font-brand p-1">Phoenix Framework</p>
                  <p class="font-normal font-brand text-gray-300 px-2 pb-1">A web development framework implementing server-side MVC pattern for Elixir apps.</p>
                  <div class="flex group items-center border border-none rounded-lg py-[0.2rem] px-[0.4rem] w-fit mx-auto bg-gistDark-light">
                    <a href="https://www.phoenixframework.org/" target="_blank" class="text-gistLav-dark group-hover:text-gistLav-light transition p-1">https://www.phoenixframework.org/</a>
                      <img src="/images/external-link.svg" alt="Elixir External Link" class="w-5 h-5 mx-auto  group-hover:text-gistLav-light group-hover:fill-gistLav-light group-hover:translate-x-[1px] group-hover:-translate-y-[2px] transition" />
                  </div>
                </div>
              </div>

              <div class="border border-gistPurp-light max-w-[22rem] w-full h-48 rounded-lg shrink-0 m-4">
                <div id="phoenix-box" class="bg-gistDark h-full w-full rounded-lg content-center space-y-1">
                  <img src="/images/phoenix.png" alt="Phoenix Logo" class="w-auto h-8 mx-auto">
                  <p class="font-bold font-brand p-1">Phoenix LiveView</p>
                  <p class="font-normal font-brand text-gray-300 px-2 pb-1">Enables rich, real-time user experiences with server-rendered HTML.</p>
                  <div class="flex group items-center border border-none rounded-lg py-[0.2rem] px-[0.4rem] w-fit mx-auto bg-gistDark-light">
                    <a href="https://hexdocs.pm/phoenix_live_view/" target="_blank" class="text-gistLav-dark group-hover:text-gistLav-light transition p-1">https://hexdocs.pm/phoenix_live_view/</a>
                      <img src="/images/external-link.svg" alt="Elixir External Link" class="w-5 h-5 mx-auto  group-hover:text-gistLav-light group-hover:fill-gistLav-light group-hover:translate-x-[1px] group-hover:-translate-y-[2px] transition" />
                  </div>
                </div>
              </div>

              <div class="border border-gistPurp-light max-w-[22rem] w-full h-48 rounded-lg shrink-0 m-4">
                <div id="phoenix-box" class="bg-gistDark h-full w-full rounded-lg content-center space-y-1">
                  <img src="/images/Tailwind_CSS_Logo.svg.png" alt="Phoenix Logo" class="w-auto h-6 mx-auto">
                  <p class="font-bold font-brand p-1">Tailwind CSS</p>
                  <p class="font-normal font-brand text-gray-300 px-2 pb-1">A utility-first CSS framework that can be used to build any design, directly in your markup.</p>
                  <div class="flex group items-center border border-none rounded-lg py-[0.2rem] px-[0.4rem] w-fit mx-auto bg-gistDark-light">
                    <a href="https://tailwindcss.com/" target="_blank" class="text-gistLav-dark group-hover:text-gistLav-light transition p-1">https://tailwindcss.com/</a>
                      <img src="/images/external-link.svg" alt="Elixir External Link" class="w-5 h-5 mx-auto  group-hover:text-gistLav-light group-hover:fill-gistLav-light group-hover:translate-x-[1px] group-hover:-translate-y-[2px] transition" />
                  </div>
                </div>
              </div>

              <div class="border border-gistPurp-light max-w-[22rem] w-full h-48 rounded-lg shrink-0 m-4">
                <div id="phoenix-box" class="bg-gistDark h-full w-full rounded-lg content-center space-y-1">
                  <img src="/images/Postgresql_elephant.svg.png" alt="Phoenix Logo" class="w-auto h-8 mx-auto">
                  <p class="font-bold font-brand p-1">PostgreSQL</p>
                  <p class="font-normal font-brand text-gray-300 px-2 pb-1">A powerful object-relational database with strong reliability, robustness, and performance.</p>
                  <div class="flex group items-center border border-none rounded-lg py-[0.2rem] px-[0.4rem] w-fit mx-auto bg-gistDark-light">
                    <a href="https://www.postgresql.org/" target="_blank" class="text-gistLav-dark group-hover:text-gistLav-light transition p-1">https://www.postgresql.org/</a>
                      <img src="/images/external-link.svg" alt="Elixir External Link" class="w-5 h-5 mx-auto  group-hover:text-gistLav-light group-hover:fill-gistLav-light group-hover:translate-x-[1px] group-hover:-translate-y-[2px] transition" />
                  </div>
                </div>
              </div>

            </div>
          </section>

          <h3 class="font-brand font-regular text-white/90 text-lg text-center px-10 pt-10">
            The aim of this project is to replicate the general functionality of
            <a href="https://gist.github.com" target="_blank" class="text-gistLav-dark hover:text-gistLav-light transition">gist.github.com</a>
            using Elixir and the Phoenix Framework.
          </h3>
          <h3 class="font-brand font-regular text-white/90 text-lg text-center px-10">
            I wanted to challenge myself to learn a new language and also tkae some creative liberties to customize the site to my liking!
          </h3>
          <h3 class="font-brand font-regular text-white/90 text-lg text-center px-10 pt-8">
            I have had a lot of fun learning Elixir and Phoenix! I think it's now one of my favorite languages to use, even though it's pretty different from most other modern langauges.
            I would love to use it for more projects in the future as well.
          </h3>
          <h3 class="font-brand font-regular text-white/90 text-lg text-center px-10 pt-10">
            The source code for this project is available here:
            <a href="https://github.com/crscobar/GistsElixir" target="_blank" class="text-gistLav-dark hover:text-gistLav-light transition">https://github.com/crscobar/GistsElixir</a>
          </h3>
          <h3 class="font-brand font-regular text-white/90 text-lg text-center px-10 pt-10">
            To contact me or view my other projects/work experience, visit:
            <a href="https://chrisescotech.vercel.app/" target="_blank" class="text-gistLav-dark hover:text-gistLav-light transition">https://chrisescotech.vercel.app/</a>
          </h3>
          <h3 class="font-brand font-regular text-white/90 text-lg text-center px-10 pt-10">
            Thanks for stopping by! :)
          </h3>
        </div>
      </div>
    """
  end
end
