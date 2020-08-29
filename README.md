# kindind

Sample setup to run [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker) in
Docker.

Also (and actually most important to me) works on Linux hosts running on ZFS
(without messing up the host's pool) by using
[aufs](https://github.com/containerd/aufs) as storage driver for
[containerd](https://containerd.io/).

## Starting

```shell
docker-compose up --build
```

## Using

```shell
docker-compose exec kind bash -il
```

Then, inside the kind container, for example:

```text
$ docker-compose exec kind bash -il
42d990a187e5:~# kubectl run netshoot --pod-running-timeout=3m --restart=Never \
> --image=nicolaka/netshoot --command -- tail -f /dev/null
pod/netshoot created
42d990a187e5:~# kubectl get pods
NAME       READY   STATUS    RESTARTS   AGE
netshoot   1/1     Running   0          14s
42d990a187e5:~# kubectl exec -it netshoot -- ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=55 time=14.5 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=55 time=13.4 ms
^C
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 13.353/13.941/14.529/0.588 ms
42d990a187e5:~#
```
