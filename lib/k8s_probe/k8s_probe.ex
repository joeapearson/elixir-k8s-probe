defmodule K8sProbe do
  use Supervisor

  @config_schema [
    port: [
      type: :pos_integer,
      default: 9991
    ],
    probe_module: [
      type: :atom,
      default: K8sProbe.DefaultProbe
    ]
  ]

  @doc """
  Starts an instance of K8sProbe.

  ## Options

  #{NimbleOptions.docs(@config_schema)}
  """
  def start_link(opts \\ []) do
    validated_opts = NimbleOptions.validate!(opts, @config_schema)
    Supervisor.start_link(__MODULE__, validated_opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    probe_module = Keyword.get(opts, :probe_module)
    port = Keyword.get(opts, :port)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: {K8sProbe.Endpoint, [probe_module: probe_module]},
        options: [port: port]
      )
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
