import difflib
import re
import shutil
import subprocess


def check_strings(string1, string2):
    if string1 != string2:
        print(
            "\n".join(
                difflib.unified_diff(
                    string1.splitlines(),
                    string2.splitlines(),
                    n=3,
                )
            )
        )
        assert False


def replace_work_dir(work_dir, string):
    return re.sub(r"{work_dir}", str(work_dir), string)


def check_output(request, cmd, work_dir, rel_dir=None):
    pwd = request.node.path.parent
    ref = pwd / "ref"
    projects = pwd / "projects"

    base = work_dir / "projects"
    shutil.copytree(projects, base)
    result = subprocess.run(
        cmd,
        cwd=base / rel_dir if rel_dir else base,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    if result.returncode != 0:
        print("=== STDOUT")
        print(result.stdout)
        print("=== STDERR")
        print(result.stderr)
        assert False

    reference = ref / f"{request.node.name}.yaml"
    stdout = ref / f"{request.node.name}.stdout"
    stderr = ref / f"{request.node.name}.stderr"
    config = base / "mani.yaml"
    assert config.is_file()
    check_strings(reference.read_text(), config.read_text())
    check_strings(
        (
            replace_work_dir(work_dir, stdout.read_text())
            if stdout.is_file()
            else ""
        ),
        result.stdout,
    )
    check_strings(
        (
            replace_work_dir(work_dir, stderr.read_text())
            if stderr.is_file()
            else ""
        ),
        result.stderr,
    )
