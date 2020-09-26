defmodule K8sProbe.MixProject do
  use Mix.Project

  def project do
    [
      app: :k8s_probe,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:plug_cowboy],
      mod: {K8sProbe.Application, []},
      env: [
        port: 9991
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      description:
        "Provides a Kubernetes liveness, readiness and health check endpoint, configurable with your own custom callbacks to suit the needs of your application.",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joeapearson/elixir-k8s-probe"}
    ]
  end
end
