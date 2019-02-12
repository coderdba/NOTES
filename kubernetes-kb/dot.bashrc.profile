
set -o vi
export PATH=$PATH:.
alias pods='kubectl get pods --all-namespaces -o wide'
alias svc='kubectl get svc --all-namespaces -o wide'
alias ep='kubectl get endpoints --all-namespaces -o wide'
alias dep='kubectl get deployments --all-namespaces -o wide'
