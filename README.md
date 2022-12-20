# docker-tls
Scripts to configure Docker with TLS on servers

## Advertisments

Replace
```
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

By
```
ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock
```
in `/lib/systemd/system/docker.service`

Run `systemctl daemon-reload` after that change.
