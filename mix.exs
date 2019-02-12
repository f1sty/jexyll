defmodule Jexyll.MixProject do
  use Mix.Project

  def project do
    [
      app: :jexyll,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # TODO: implement yaml config file support
      {:yamerl, "~> 0.7.0"},
      {:jason, "~> 1.1"},
      {:earmark, "~> 1.3"},
      {:credo, "~> 1.0", only: [:dev, :test]}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
