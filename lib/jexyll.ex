defmodule Jexyll do
  @moduledoc false

  @default_type :html

  def start(config_file \\ "jexyll.json") do
    config = config(config_file)

    src_dir = get_in(config, ~w/site src_dir/)
    build_dir = get_in(config, ~w/site build_dir/)

    vars =
      get_in(config, ~w/site env/)
      |> Enum.reduce(%{}, &Map.merge(&2, &1))
      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)

    files =
      src_dir
      |> glob_type()
      |> Enum.map(&parse_filename/1)
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.update(acc, k, [v], &[v | &1]) end)

    files.html
    |> Stream.map(fn file -> {String.replace(file, src_dir, build_dir) <> ".html", File.read!(file <> ".md") |> EEx.eval_string(vars)} end)
    |> Stream.map(fn {file, parsed} -> {file, Earmark.as_html!(parsed)} end)
    |> Enum.each(&write_parsed/1)
  end

  defp config(config_file) do
    config_file
    |> Path.absname()
    |> File.read!()
    |> Jason.decode!()
  end

  defp parse_filename(filename, type \\ :md) do
    basepath =
      case type do
        :md -> String.trim_trailing(filename, ".md")
        :eex -> String.trim_trailing(filename, ".eex")
        _ -> raise("type #{type} not implemented yet")
      end

    {@default_type, basepath}
  end

  defp glob_type(src_dir, type \\ :md) do
    src_dir
    |> Path.join("**/*.#{type}")
    |> Path.wildcard()
  end

  defp write_parsed({filename, content}) do
    filename
    |> Path.dirname()
    |> File.mkdir_p!()

    filename
    |> File.open!([:write])
    |> IO.write(content)
  end
end
