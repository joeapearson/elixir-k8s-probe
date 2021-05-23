defmodule K8sProbe.Probe do
  @callback readiness() :: :ok | :error
  @callback liveness() :: :ok | :error

  def liveness, do: :ok
  def readiness, do: :ok
end
