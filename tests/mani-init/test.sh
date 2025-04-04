#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

function color() 
{
    printf "\e[38;5;%sm%s\e[m" "$1" "$2"
}

function fail() {
    echo
    diff  <(echo "$expected") <(echo "$actual") --color=always
    printf "%s" "$line"
    color 1 FAIL
    echo
}

function test() {
    name="$1"
    cmd="$2"
    expected="$3"
    line="....................................................................... "

    pushd "projects" &>/dev/null || return 1
    config="$(realpath "${PWD}/mani.yaml")"

    printf "[%s] %s" "$name" "${line:$((${#name} + 3))}"
    stdout="$(eval "$cmd" 2>&1)"
    actual="$(cat "$config")"
    if [[ -n "$stdout" ]]
    then
        echo
        echo "$stdout"
        printf "%s" "$line"
    fi
    if [[ "$expected" == "$actual" ]]
    then
        color 2 OK
        echo
    else
        fail
    fi

    rm "${config}"
    popd &>/dev/null || return 1
}

test "Default init" "mani-init" "projects:
  project3:
    sync: false
  sub/project6:
    sync: false"

test "Default init - name" "mani-init -n 'basename \$PWD'" "projects:
  project3:
    sync: false
  project6:
    path: sub/project6
    sync: false"

test "Init with file" "mani-init -f file1.txt" "projects:
  project1:
    sync: false
  sub/project4:
    sync: false"

test "Init with file - name" "mani-init -f file1.txt -n 'cd ..; basename \$PWD'" "projects:
  projects:
    path: project1
    sync: false
  sub:
    path: sub/project4
    sync: false"

test "Init with file" "mani-init -f file2.txt" "projects:
  project2:
    sync: false
  sub/project5:
    sync: false"

test "Init with file - name" "mani-init -f file2.txt -n 'cd ..; basename \$PWD'" "projects:
  projects:
    path: project2
    sync: false
  sub:
    path: sub/project5
    sync: false"

test "No projects" "mani-init -f random.txt; touch mani.yaml" ""

test "Exists" "echo Alpha > mani.yaml; mani-init" "Alpha"

test "Sync default" \
    "echo projects: > mani.yaml; echo '  current:' >> mani.yaml; echo '     sync: false' >> mani.yaml; mani-init -s" \
    "projects:
  current:
    sync: false
  project3:
    sync: false
  sub/project6:
    sync: false"

test "Sync file" \
    "echo projects: > mani.yaml; echo '  current:' >> mani.yaml; echo '     sync: false' >> mani.yaml; mani-init -f file1.txt -s" \
    "projects:
  current:
    sync: false
  project1:
    sync: false
  sub/project4:
    sync: false"

