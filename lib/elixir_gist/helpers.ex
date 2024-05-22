defmodule ElixirGist.Helpers do
  def get_relative_time(gist) do
    relative_time = Timex.format(gist.updated_at, "{relative}", :relative)
    relative_time
  end
end
