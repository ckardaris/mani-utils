from ..utils import check_output


def test_default_init(request, tmp_path):
    check_output(
        request,
        """
mkdir -p project3/.git sub/project6/.git
mani-init &>/dev/null""",
        tmp_path,
    )


def test_default_init_name(request, tmp_path):
    check_output(
        request,
        """
mkdir -p project3/.git sub/project6/.git
mani-init -n 'basename $PWD' &>/dev/null
""",
        tmp_path,
    )


def test_init_file1(request, tmp_path):
    check_output(request, "mani-init -f file1.txt &>/dev/null", tmp_path)


def test_init_file2(request, tmp_path):
    check_output(request, "mani-init -f file2.txt &>/dev/null", tmp_path)


def test_init_file1_name(request, tmp_path):
    check_output(
        request,
        "mani-init -f file1.txt -n 'cd ..; basename $PWD' &>/dev/null",
        tmp_path,
    )


def test_init_file2_name(request, tmp_path):
    check_output(
        request,
        "mani-init -f file2.txt -n 'cd ..; basename $PWD' &>/dev/null",
        tmp_path,
    )


def test_no_files(request, tmp_path):
    check_output(
        request,
        """
mani-init -f random.txt
touch mani.yaml
""",
        tmp_path,
    )


def test_exists(request, tmp_path):
    check_output(
        request,
        """
echo projects: > mani.yaml
mani-init
""",
        tmp_path,
    )


def test_sync_default(request, tmp_path):
    check_output(
        request,
        """
echo 'projects:' > mani.yaml
echo '  current:' >> mani.yaml
echo '    sync: false' >> mani.yaml
mkdir -p project3/.git sub/project6/.git
mani-init -s &>/dev/null
""",
        tmp_path,
    )


def test_sync_file(request, tmp_path):
    check_output(
        request,
        """
echo 'projects:' > mani.yaml
echo '  current:' >> mani.yaml
echo '    sync: false' >> mani.yaml
mani-init -s -f file1.txt &>/dev/null
""",
        tmp_path,
    )
