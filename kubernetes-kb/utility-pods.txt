BUSYBOX
https://medium.com/@pczarkowski/kubernetes-tip-run-an-interactive-pod-d701766a12
kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh

LINUX CURL
docker pull pstauffer/curl

docker run -d --name curl pstauffer/curl:latest
docker run --rm --name curl pstauffer/curl:latest curl --version
docker run --rm --name curl pstauffer/curl:latest curl http://www.google.ch

kubectl run -i --tty --rm debug --image=pstauffer/curl --restart=Never -- sh
