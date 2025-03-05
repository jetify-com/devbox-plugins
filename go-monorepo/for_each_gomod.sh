# Shell function that evals its arguments inside each Go module in the
# workspace. For example, `for_each_gomod go test ./...` runs tests for
# every module.
pwd="$(pwd)"
for dir in $(go list -m -f '{{`{{.Dir}}`}}'); do
  echo "$dir: $*" && cd "$dir" && "$@"
done
cd "$pwd" || return
