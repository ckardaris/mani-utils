# mani-init

`mani-init` can be used to initialize or sync a `mani.yaml` configuration file with non-git
directories.

<!-- REQUIRE_BEGIN - AUTOMATICALLY GENERATED -->
### Requirements
- `fd`
- `flock`
- `yq`
<!-- REQUIRE_END - AUTOMATICALLY GENERATED -->
<!-- USAGE_BEGIN - AUTOMATICALLY GENERATED -->
### Usage
``` bash
USAGE:
  mani-init [OPTIONS]

OPTIONS:
  -f file1,file2,...          Select file to create project from
                              (default: .git)
  -n CMD                      Run command on project directory to assign a name
                              (default: relative path from 'mani.yaml').
  -s                          Sync existing 'mani.yaml' with additional projects.
  -h                          Show this help message
```
<!-- USAGE_END - AUTOMATICALLY GENERATED -->

### Examples

1. Create from a single file

You can use `mani-init` by providing a single file name.

``` bash
mani-init -f .marker
```

This will search for files or directories named `.marker` in the current
directory tree and add their parent directory as a project to the generated
`mani.yaml`.

These projects will not have the `path` attribute configured for them.
The name of the project will be the relative path from the directory of the
`mani.yaml` configuration file.

2. Create from a file and assign custom names for the projects

If a different name for the projects is desired you can use the `-n` option
with a shell command.

``` bash
mani-init -f .marker -n 'basename $PWD'
```

This will create projects and their name will be the name of the parent
directory (similarly to how `mani` initialization works by default for git
projects).

The `path` attribute will be set to the relative path from the directory of the
`mani.yaml` configuration file.

3. Create from multiple files

You can also provide multiple file names to create projects from.

``` bash
mani-init -f .marker1,.marker2
```

4. Extend existing `mani.yaml` configuration.

If a `mani.yaml` file is exists, `mani-init` won't attemp to overwrite it. Option `-s` can be used to extend it instead.

``` bash
mani-init -s -f .marker
```
This will add projects based on file `.marker` to the existing `mani.yaml` configuration file.

### Notes
All projects created by `mani-init` additionally set the `sync` attribute. Its value is `false`.
