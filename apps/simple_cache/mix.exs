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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:sasl, :logger],
      mod: {SimpleCache.App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 1.0"}
    ]
  end
end
