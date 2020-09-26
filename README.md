# K8sProbe

Provides configurable HTTP liveness, readiness and health endpoints, intended to be used to support
Kubernetes probes.

## Installation

Add `k8s_probe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:k8s_probe, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/k8s_probe](https://hexdocs.pm/k8s_probe).
