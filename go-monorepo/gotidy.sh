#!/bin/bash
# shellcheck shell=sh

# Credit to @gcurtis for this script! 

set -e

if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
	echo "usage: $0 [-u | -u direct | -u go]"
	echo
	echo "gotidy tidies the go.mod files in the current repo and checks that each module"
	echo "compiles independently of the workspace. If -u is set, it also updates the"
	echo "dependencies of each module. If -u is set to \"go\" then it only updates the Go"
	echo "version. If -u is set to \"direct\" then it only updates the direct dependencies"
	echo "of each module. Restricting updates to direct dependencies is useful when there"
	echo "are prerelease packages with updates that aren't backwards compatible."
	exit 2
fi

if [ "$1" = "-u" ]; then
	case "$2" in
	"")
		update_deps=1
		;;
	"direct")
		update_deps=1
		direct_deps_only=1
		;;
	"go")
		update_go=1
		;;
	*)
		echo "invalid value \"$2\" for -u flag (must be empty, \"direct\", or \"go\")"
		exit 1
		;;
	esac
elif [ "$1" != "" ]; then
	echo "invalid flag \"$1\""
	exit 1
fi

# Restore the current directory before exiting.
pwd="$(pwd)"
trap 'cd "${pwd}"' EXIT INT TERM HUP

# Start at the repo root to get a list of all Go modules in the workspace.
repo="$(git rev-parse --show-toplevel)"
cd "${repo}"

# go work use to make sure the workspace Go version is compatible with the
# modules' Go versions.
go work use
mods="$(go list -m -f "{{`{{.Dir}}`}}")"

# TODO: Add a script that runs this with GOWORK=off to check that the modules
# build with the workspace disabled. This is useful to ensure that the modules
# are self-contained and don't rely on the workspace for dependencies.
# export GOWORK=off

# Update the Go version first, since that will influence how Go updates
# dependencies and tidies the modules.
if [ "${update_go}" = 1 ]; then
	for dir in ${mods}; do
		if ! cd "${dir}"; then
			echo "$0: ${dir}: skipping directory"
			continue
		fi

		echo "$0: ${dir}: checking for newer Go version"
		go get go@latest
	done
fi

if [ "${update_deps}" = 1 ]; then
	for dir in ${mods}; do
		if ! cd "${dir}"; then
			echo "$0: ${dir}: skipping directory"
			continue
		fi

		# Tidy before the update to make sure all the necessary
		# dependencies are in go.mod.
		echo "$0: ${dir}: tidying go.mod"
		go mod tidy -e

		# Manually list out the dependencies instead of go get -u ./...
		# so we can filter them.
		echo "$0: ${dir}: checking for dependency updates"
		deps="$(go mod edit -json | jq -c ".Require[]")"
		for dep in ${deps}; do
			dep_path="$(echo "${dep}" | jq -r ".Path")"
			if [ "${direct_deps_only}" = 1 ] && echo "${dep}" | jq -e ".Indirect" >/dev/null; then
				echo "$0: ${dir}: skipping indirect dependency ${dep_path}"
				continue
			fi

			# To temporarily skip a problematic update:
			#
			# if [ "${dep_path}" = "bad_dependency" ]; then
			# 	continue
			# fi
			echo "$0: ${dir}: checking for updates to ${dep_path}"
			go get -u -t "${dep_path}"
		done
	done
fi

# Final tidy and ensure all packages build without the workspace.
for dir in ${mods}; do
	if ! cd "${dir}"; then
		echo "$0: ${dir}: skipping directory"
		continue
	fi

	echo "gotidy ${dir}: tidying go.mod"
	go mod tidy

	echo "gotidy ${dir}: downloading dependencies"
	go mod download

	echo "gotidy ${dir}: formatting module"
	go fmt ./...

	echo "gotidy ${dir}: building module"
	go build ./...

	echo "gotidy ${dir}: building module tests"
	go test -c -o /dev/null ./...
done

# Reenable the workspace to sync all of the modules' transitive
# dependencies and ensure everything still builds.
export GOWORK=auto
cd "${repo}"
go work sync
go mod download

for dir in ${mods}; do
	if ! cd "${dir}"; then
		echo "$0: ${dir}: skipping directory"
		continue
	fi

	echo "gotidy ${dir}: building module"
	go build ./...

	echo "gotidy ${dir}: building module tests"
	go test -c -o /dev/null ./...
done

git --no-pager diff --stat
