# mani-tag

`mani-init` can be used to manipulate the `tags` attribute of your `mani.yaml` projects.
It supports:
- execution from inside the directory of `mani.yaml`.
- execution from inside the directory of the different projects.<br>
In this case, the modifications to the `mani.yaml` file are atomic, permitting using `mani-tag` in a
`mani exec/run` command.

<!-- REQUIRE_BEGIN - AUTOMATICALLY GENERATED -->
### Requirements
- `flock`
- `yq`
<!-- REQUIRE_END - AUTOMATICALLY GENERATED -->
<!-- USAGE_BEGIN - AUTOMATICALLY GENERATED -->
### Usage
``` bash
USAGE:
  mani-tag [OPTIONS]

OPTIONS:
  -p project1,project2,...    Select project (default: current directory)
  -P                          Select all projects
  -a tag1,tag2,...            Add tags to projects
  -d tag1,tag2,...            Delete tags from projects
  -c                          Clear all tags for projects
  -h                          Show this help message
```
<!-- USAGE_END - AUTOMATICALLY GENERATED -->

### Examples

1. Add tags to projects

``` bash
mani-tag -p project1,project2 -a success
```
This will add the tag `success` to projects `project1` and `project2`.

2. Delete tags from projects

``` bash
mani-tag -p project1,project2 -d success
```
This will remove the tag `success` from projects `project1` and `project2`.

3. Clear tags from projects

``` bash
mani-tag -p project1,project2 -c
```
This will remove (clear) all tags from projects `project1` and `project2`.

3. Select all projects

Options `-P` can be used to select all projects specified in the `mani.yaml` configuration file.
``` bash
mani-tag -P -c
```
This will remove (clear) all tags from all projects.

4. Change tags of the current project

If `mani-tag` is run inside the directory of a project specified in a `mani.yaml` configuration
file, then the project selection options are not used.
`mani-tag` will try to find a project in a `mani.yaml` configuration file in one of the parent
directories that matches the current directory and change the tags of this project.

A project match may not be found in the first encountered `mani.yaml` configuration file (e.g.
nested `mani.yaml` configurations).
In that case `mani-tag` will search in the parent directories to find a suitable match. 

In order for a `mani.yaml` configuration file to be a match, it needs to have a project with a name
or `path` attribute that is the same as the relative path to the starting directory.

``` bash
mani-tag -a success
```
This command will tag the project residing in the current directory (if one is found).

This calling syntax permits doing the following:

``` bash
mani exec 'my_command && mani-tag -a success || mani-tag -a failure'
```
This will run `my_command` inside all the project directories and tag the respective projects
according to the exit status of the command.

Afterwards it is easy, for example, to re-run the command only for those projects that previously
failed.

``` bash
mani exec -t failure 'my_command && mani-tag -a success || mani-tag -a failure'
```
