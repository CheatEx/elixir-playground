defmodule SimpleCacheServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_cache_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:sasl, :logger],
      mod: {SimpleCacheServer.Application, []}
    ]
  end

  defp deps do
    [
      {:simple_cache, in_umbrella: true}
    ]
  end
end
