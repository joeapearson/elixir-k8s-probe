defmodule K8sProbe.DefaultProbe do
  @moduledoc """
  Provides a default probe implementation that responds successfully in all cases, regardless of the
  actual state of your application.
  """

  @behaviour K8sProbe.Probe

  def liveness, do: :ok
  def readiness, do: :ok
end
