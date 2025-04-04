#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

function color() 
{
    printf "\e[38;5;%sm%s\e[m" "$1" "$2"
}

function test() {
    name="$1"
    cmd="$2"
    expected="$3"
    line="....................................................................... "

    pushd "projects" &>/dev/null || return 1
    config="$(realpath "${PWD}/mani.yaml")"
    cp "$config" "${config}.bak"

    pushd "${4-$PWD}" &>/dev/null || return 1
    stdout="$(eval "$cmd")"
    printf "[%s] %s" "$name" "${line:$((${#name} + 3))}"
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
        echo
        diff  <(echo "$expected") <(echo "$actual") --color=always
        printf "%s" "$line"
        color 1 FAIL
        echo
    fi

    popd &>/dev/null || return 1
    mv "${config}.bak" "${config}"
    popd &>/dev/null || return 1
}

test "Add one tag - one project" "mani-tag -p project1 -a fail" "projects:
  project1:
    tags:
      - fail
      - tag1
  project2:
    tags:
      - tag1
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"

test "Add one tag - multiple projects" "mani-tag -p project1,project3 -a fail" "projects:
  project1:
    tags:
      - fail
      - tag1
  project2:
    tags:
      - tag1
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - fail
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"

test "Add one tag - all projects" "mani-tag -P -a fail" "projects:
  project1:
    tags:
      - fail
      - tag1
  project2:
    tags:
      - fail
      - tag1
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - fail
      - tag1
  project4:
    path: sub/project4
    tags:
      - fail
      - tag1
      - tag2
      - tag3"

test "Add multiple tags - one project" "mani-tag -p project1 -a success,fail" "projects:
  project1:
    tags:
      - fail
      - success
      - tag1
  project2:
    tags:
      - tag1
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"

test "Add multiple tags - multiple projects" "mani-tag -p project1,project3 -a success,fail" "projects:
  project1:
    tags:
      - fail
      - success
      - tag1
  project2:
    tags:
      - tag1
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - fail
      - success
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"


test "Delete one tag - one project" "mani-tag -p project2 -d tag1" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags:
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"

test "Delete one tag - multiple projects" "mani-tag -p project2,project4 -d tag1" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags:
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag2
      - tag3"

test "Delete one tag - all projects" "mani-tag -P -d tag1" "projects:
  project1:
    tags: []
  project2:
    tags:
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags: []
  project4:
    path: sub/project4
    tags:
      - tag2
      - tag3"

test "Delete multiple tags - one project" "mani-tag -p project2 -d tag1,tag3" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags:
      - tag2
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"

test "Delete multiple tags - multiple projects" "mani-tag -p project2,project4 -d tag1,tag3" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags:
      - tag2
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag2"

test "Clear tags - one project" "mani-tag -p project2 -c" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags: []
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"

test "Clear tags - multiple projects" "mani-tag -p project2,project4 -c" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags: []
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags: []"

test "Clear tags - all projects" "mani-tag -P -c" "projects:
  project1:
    tags: []
  project2:
    tags: []
  project3:
    path: sub/project3
    tags: []
  project4:
    path: sub/project4
    tags: []"

test "Sort tags" "mani-tag -p project2 -a tag1a,tag2a" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags:
      - tag1
      - tag1a
      - tag2
      - tag2a
      - tag3
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3"

test "Add one tag - current project" "mani-tag -a fail" "projects:
  project1:
    tags:
      - tag1
  project2:
    tags:
      - fail
      - tag1
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3" "project2"

test "Add one tag - current project - mani.yaml collision" "mani-tag -a fail" "projects:
  project1:
    tags:
      - fail
      - tag1
  project2:
    tags:
      - tag1
      - tag2
      - tag3
  project3:
    path: sub/project3
    tags:
      - tag1
  project4:
    path: sub/project4
    tags:
      - tag1
      - tag2
      - tag3" "project1" 
