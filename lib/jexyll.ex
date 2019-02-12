defmodule Jexyll do
  @moduledoc false

  def start(config_file \\ "jexyll.json") do
    config = config(config_file)

    config
    |> get_in(~w/site src_dir/)
    |> File.ls!
  end

  defp config(config_file) do
    config_file
    |> Path.absname()
    |> File.read!()
    |> Jason.decode!()
  end
end
