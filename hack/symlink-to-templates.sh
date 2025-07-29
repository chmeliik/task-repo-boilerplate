#!/bin/bash
set -o errexit -o nounset -o pipefail

find '{{cookiecutter.repo_root}}' -type f | while read -r actual_path; do
    link_path=${actual_path#*/}
    dirname=$(dirname "$link_path")

    actual_path_relative_to_link=$(realpath "$actual_path" --relative-to "$dirname")

    mkdir -p "$dirname"

    if [[ -L "$link_path" ]] || cmp -s "$link_path" "$actual_path"; then
        # file already exists and is a symlink or is identical to target file
        # force-replace with correct symlink
        ln -sf "$actual_path_relative_to_link" "$link_path"
    else
        # error out if file already exists
        ln -s "$actual_path_relative_to_link" "$link_path"
    fi

    git add "$link_path"
done
