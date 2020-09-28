defmodule K8sProbe.Application do
  @moduledoc """


  """

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: K8sProbe.Worker.start_link(arg)
      # {K8sProbe.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug:
          {K8sProbe.Endpoint,
           [probe_module: Application.get_env(:k8s_probe, :probe_module, K8sProbe.DefaultProbe)]},
        options: [port: Application.get_env(:k8s_probe, :port)]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: K8sProbe.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
