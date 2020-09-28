# K8sProbe

Provides configurable HTTP liveness and readiness endpoints, intended to be used to support
[Kubernetes probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).

`K8sProbe` ships with a built-in `Cowboy` HTTP server making this module easy to integrate into
any project.

## Usage

### Installation

First, add `:k8s_probe` to your `mix.exs` dependencies like so:

    defp deps do
      [
        # … your other various dependencies
        {:k8s_probe, "0.1.0"}
      ]
    end

If necessary run `mix deps.get` and `mix deps.compile` at this point to fetch and compile
K8sProbe.

Next, add `:k8s_probe` to your extra applications in `mix.exs` to have it be started along with the
rest of your application.

Now you can try it out by launching your application and making a request to the probe endpoints
as follows:

```sh
$ iex -S mix
… your app starts up

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

    defmodule MyApp.MyProbe do
      @behaviour K8sProbe.Probe
      def readiness, do: :ok
      def liveness, do: :ok
    end

Each of the three probes must be a function that returns either `:ok` or `:error`.  How you
implement your probe really depends on your application.

Having written your probe, you can configure K8sProbe to use it in your configuration like so:

    config :k8s_probe, :probe_module, MyApp.MyProbe

## Configuration

Generally it's recommended to just use the default configuration; easier isn't it!  But if you
must then read on...

### Port

By default K8sProbe listens on port 9991.  You may override it in your configuration like so:

    config :k8s_probe, port: 8080

### Paths

By default the probes listen at `/liveness` and `/readiness`.  You may customise these
paths if you wish as follows:

    config :k8s_probe, :liveness_path, "/my_liveness"
    config :k8s_probe, :readiness_path, "/my_liveness"


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
