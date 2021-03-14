defmodule SimpleCache.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_cache,
      version: "0.1.0",
      elixir: "~> 1.11",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:sasl, :logger],
      mod: {SimpleCache.App, []}
    ]
  end

  defp deps do
    [
    ]
  end
end
