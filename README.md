# K8sProbe

Provides configurable HTTP liveness and readiness endpoints, intended to be used to support
[Kubernetes probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).

`K8sProbe` ships with a built-in `Cowboy` HTTP server making this module easy to integrate into
any project.

## Usage

### Installation

First, add `:k8s_probe` to your `mix.exs` dependencies like so:

```elixir
defp deps do
  [
    # … your other various dependencies
    {:k8s_probe, "0.3.0"}
  ]
end
```

If necessary run `mix deps.get` and `mix deps.compile` at this point to fetch and compile
K8sProbe.

Next, add `K8sProbe` to your supervision tree (perhaps in your `application.ex` file).  It would
look something like this:

```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      K8sProbe
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Now you can try it out by launching your application and making a request to the probe endpoints
as follows:

```sh
# Start your app in iex
$ iex -S mix

# In another terminal
$ curl localhost:9991/readiness
OK
$ curl localhost:9991/liveness
OK
```

Congratulations, you have a default probe up and running!

### Customising the probe

This module ships with a completely minimal default probe that does nothing other than respond
with a `200 OK`, regardless of the state of your application.

This might be fine for simple applications, but for a more detailed implementation you need to
provide your own probe implementing the `K8sProbe.Probe` behaviour.  Here's an example:

```elixir
defmodule MyApp.MyProbe do
  @behaviour K8sProbe.Probe
  def readiness, do: :ok
  def liveness, do: :ok
end
```

Each of the three probes must be a function that returns either `:ok` or `:error`.  How you
implement your probe really depends on your application.

Having written your probe, you can configure K8sProbe to use it by passing it in the configuration.
Here's what your `application.ex` file might look like:

```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      {K8sProbe, probe_module: MyApp.MyProbe}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

## Configuration

Generally it's recommended to just use the default configuration; easier isn't it!  But if you
must then read on...

### Port

By default K8sProbe listens on port 9991.  You may override it by passing it as config option.

## Configuring probes in Kubernetes

Here's an example Kubernetes deployment in YAML format that calls the probes as implemented by
default:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-service
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: my-service
  template:
    spec:
      containers:
        name: my-service
        image: my-service
        ports:
          - containerPort: 9991
            name: liveness-port
            protocol: TCP
        readinessProbe:
          httpGet:
            path: /readiness
            port: liveness-port
        livenessProbe:
          httpGet:
            path: /liveness
            port: liveness-port
        startupProbe:
          httpGet:
            path: /readiness
            port: liveness-port
```

You'll need to modify this configuration before it will work of course, replacing the image with
your own.

Configuring Kubernetes to make use of the probes provided by this module is a topic unto itself.
See
[here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
for more information.
