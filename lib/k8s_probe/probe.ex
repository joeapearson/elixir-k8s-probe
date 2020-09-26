defmodule K8sProbe.Probe do
  @callback health() :: :ok | :error
  @callback readiness() :: :ok | :error
  @callback liveness() :: :ok | :error
end
