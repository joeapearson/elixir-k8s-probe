defmodule K8sProbe.Application do
  @moduledoc """
  K8sProbe provides configurable HTTP liveness, readiness and health endpoints, intended to be used
  to support Kubernetes probes.

  ## Usage

  ## Installation

  First, add `:k8s_probe` to your `mix.exs` dependencies like so:

      defp deps do
        [
          # … your other various dependencies
          {:k8s_probe, "0.1.0"}
        ]
      end

  If necessary run `mix deps.get` and `mix deps.compile` at this point to fetch and compile
  K8sProbe.

  Next, add `:k8s_probe` to your extra applications in `mix.exs` to have it be started.

  Now you can try it out by launching your application and making a request to the probe endpoints
  as follows:

      $ iex -S mix
      … your app starts up

      # In another terminal
      $ curl localhost:9991/readiness
      OK
      $ curl localhost:9991/liveness
      OK
      $ curl localhost:9991/health
      OK

  Congratulations, you have a default probe up and running!

  ## Customising the probe

  This module ships with a completely minimal default probe that does nothing other than respond
  with a `200 OK`, regardless of the state of your application.

  This might be fine for simple applications, but for a more detailed implementation you need to
  provide your own probe implementing the `K8sProbe.Probe` behaviour.  Here's an example:

      defmodule MyApp.MyProbe do
        def health, do: :ok
        def readiness, do: :ok
        def liveness, do: :ok
      end

  Each of the three probes must be a function that returns either `:ok` or `:error`.

  Having written your probe, you can configure K8sProbe to use it in your configuration like so:

      config :k8s_probe, :probe_module, MyApp.MyProbe

  ## Configuration

  Generally it's recommended to just use the default configuration; easier isn't it.  But if you
  must then read on!

  ### Port

  By default K8sProbe listens on port 9991.  You may override it in your configuration like so:

      config :k8s_probe, port: 8080

  ### Paths

  By default the probes listen at `/liveness`, `/readiness` and `/health`.  You may customise these
  paths if you wish as follows:

      config :k8s_probe, :health_path, "/my_health"
      config :k8s_probe, :health_path, "/my_liveness"
      config :k8s_probe, :health_path, "/my_liveness"


  ## Configuring probes in Kubernetes

  Configuring Kubernetes to make use of the probes provided by this module is a topic unto itself.
  See
  [here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
  for more information.

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
