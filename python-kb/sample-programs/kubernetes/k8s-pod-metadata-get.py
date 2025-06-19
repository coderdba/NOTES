import socket
from kubernetes import client, config

def get_pod_metadata():
    # Load in-cluster config
    config.load_incluster_config()

    # Get current pod name and namespace
    pod_name = socket.gethostname()
    namespace = open("/var/run/secrets/kubernetes.io/serviceaccount/namespace").read()

    # Create API client
    v1 = client.CoreV1Api()

    # Get pod details
    pod = v1.read_namespaced_pod(name=pod_name, namespace=namespace)

    metadata = {
        "pod_name": pod.metadata.name,
        "namespace": pod.metadata.namespace,
        "node_name": pod.spec.node_name,
        "pod_ip": pod.status.pod_ip,
        "labels": pod.metadata.labels,
        "annotations": pod.metadata.annotations,
    }

    return metadata

if __name__ == "__main__":
    meta = get_pod_metadata()
    for key, value in meta.items():
        print(f"{key}: {value}")
