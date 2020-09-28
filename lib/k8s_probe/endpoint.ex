defmodule K8sProbe.Endpoint do
  @moduledoc """
  A plug responsible for handling kubernetes liveness and readiness check probe requests.
  """

  use Plug.Router

  # :match plug matches routes and forwards them to :dispatch plug below
  plug(:match)
  # :dispatch plug attaches builder_opts() which allows us to configure the plug
  plug(:dispatch, builder_opts())

  @liveness_path Application.get_env(:k8s_probe, :liveness_path, "/liveness")
  @readiness_path Application.get_env(:k8s_probe, :readiness_path, "/readiness")

  # Liveness endpoint
  get @liveness_path do
    probe = get_probe_module!(opts)
    check_probe(conn, &probe.liveness/0)
  end

  # Readiness endpoint
  get @readiness_path do
    probe = get_probe_module!(opts)
    check_probe(conn, &probe.readiness/0)
  end

  # Responds 404 Not Found to any other path
  match _ do
    send_resp(conn, 404, "Not Found")
  end

  # Calls the specified probe
  defp check_probe(conn, fun) do
    send_response(conn, fun.())
  end

  # Dispatches a 200 OK response since the probe has responded :ok
  defp send_response(conn, :ok) do
    send_resp(conn, Plug.Conn.Status.code(:ok), "OK")
  end

  # Dispatches 503 Service Unavailable since the probe has responded with something other than :ok
  defp send_response(conn, _) do
    send_resp(conn, 503, "Service Unavailable")
  end

  # Gets the probe module from the options provided to this plug
  defp get_probe_module!(probe_module: probe_module) do
    probe_module
  end
end
