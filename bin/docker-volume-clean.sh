docker volume ls | awk '$1 == "local" { print $2 }' | xargs --no-run-if-empty docker volume rm