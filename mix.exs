defmodule K8sProbe.MixProject do
  use Mix.Project

  def project do
    [
      app: :k8s_probe,
      version: "0.2.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
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
        "Provides configurable HTTP liveness and readiness endpoints for supporting Kubernetes probes.",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joeapearson/elixir-k8s-probe"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE"
      ],
      authors: [
        "Joe Pearson"
      ],
      api_reference: false
    ]
  end
end
