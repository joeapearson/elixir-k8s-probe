defmodule K8sProbe.MixProject do
  use Mix.Project

  @version "0.4.0"
  @repo_url "https://github.com/joeapearson/elixir-k8s-probe"

  def project do
    [
      app: :k8s_probe,
      version: @version,
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
      extra_applications: [:plug_cowboy]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:nimble_options, "~> 0.3.0"},
      {:plug_cowboy, "~> 2.5.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      description:
        "Provides configurable HTTP liveness and readiness endpoints for supporting Kubernetes probes.",
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
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
      source_ref: "v#{@version}",
      source_url: @repo_url,
      api_reference: false
    ]
  end
end
