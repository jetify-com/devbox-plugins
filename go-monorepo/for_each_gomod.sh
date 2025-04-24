# Shell function that evals its arguments inside each Go module in the
# workspace. For example, `for_each_gomod go test ./...` runs tests for
# every module.
pwd="$(pwd)"
for dir in $(go list -m -f '{{`{{.Dir}}`}}'); do
  # Skip directories that match the exclude pattern if set
  if [ -n "${DEVBOX_GO_MONOREPO_EXCLUDE}" ] && [[ "$dir" =~ ${DEVBOX_GO_MONOREPO_EXCLUDE} ]]; then
    echo "Skipping excluded directory: $dir"
    continue
  fi
  echo "$dir: $*" && cd "$dir" && "$@" || exit $?
done
cd "$pwd" || return
