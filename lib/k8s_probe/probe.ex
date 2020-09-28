defmodule K8sProbe.Probe do
  @callback readiness() :: :ok | :error
  @callback liveness() :: :ok | :error
end
