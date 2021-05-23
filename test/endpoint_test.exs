defmodule K8sProbe.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule GoodProbe do
    @behaviour K8sProbe.Probe
    def liveness, do: :ok
    def readiness, do: :ok
  end

  defmodule BadProbe do
    @behaviour K8sProbe.Probe
    def liveness, do: :error
    def readiness, do: :error
  end

  test "responds to liveness with 200 on success" do
    conn = conn(:get, "/liveness")

    conn = K8sProbe.Endpoint.call(conn, probe_module: GoodProbe)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "OK"
  end

  test "responds to liveness with 503 on error" do
    conn = conn(:get, "/liveness")

    conn = K8sProbe.Endpoint.call(conn, probe_module: BadProbe)

    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body == "Service Unavailable"
  end

  test "responds to readiness with 200 on success" do
    conn = conn(:get, "/readiness")

    conn = K8sProbe.Endpoint.call(conn, probe_module: GoodProbe)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "OK"
  end

  test "responds to readiness with 503 on error" do
    conn = conn(:get, "/readiness")

    conn = K8sProbe.Endpoint.call(conn, probe_module: BadProbe)

    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body == "Service Unavailable"
  end

  test "responds to other routes with 404" do
    conn = conn(:get, "/non-existant")

    conn = K8sProbe.Endpoint.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body
  end
end
