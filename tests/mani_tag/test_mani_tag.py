from ..utils import check_output


def test_add_one_tag_one_project(request, tmp_path):
    check_output(request, "mani-tag -p project1 -a fail", tmp_path)


def test_add_one_tag_multiple_projects(request, tmp_path):
    check_output(request, "mani-tag -p project1,project3 -a fail", tmp_path)


def test_add_one_tag_all_projects(request, tmp_path):
    check_output(request, "mani-tag -P -a fail", tmp_path)


def test_add_multiple_tags_one_project(request, tmp_path):
    check_output(request, "mani-tag -p project1 -a success,fail", tmp_path)


def test_add_multiple_tags_multiple_projects(request, tmp_path):
    check_output(
        request,
        "mani-tag -p project1,project3 -a success,fail",
        tmp_path,
    )


def test_add_multiple_tags_all_projects(request, tmp_path):
    check_output(request, "mani-tag -P -a success,fail", tmp_path)


def test_delete_one_tag_one_project(request, tmp_path):
    check_output(request, "mani-tag -p project2 -d tag1", tmp_path)


def test_delete_one_tag_multiple_projects(request, tmp_path):
    check_output(request, "mani-tag -p project2,project4 -d tag1", tmp_path)


def test_delete_one_tag_all_projects(request, tmp_path):
    check_output(request, "mani-tag -P -d tag1", tmp_path)


def test_delete_multiple_tags_one_project(request, tmp_path):
    check_output(request, "mani-tag -p project2 -d tag1,tag3", tmp_path)


def test_delete_multiple_tags_multiple_projects(request, tmp_path):
    check_output(
        request,
        "mani-tag -p project2,project4 -d tag1,tag3",
        tmp_path,
    )


def test_delete_multiple_tags_all_projects(request, tmp_path):
    check_output(request, "mani-tag -P -d tag1,tag3", tmp_path)


def test_clear_tags_one_project(request, tmp_path):
    check_output(request, "mani-tag -p project2 -c", tmp_path)


def test_clear_tags_multiple_projects(request, tmp_path):
    check_output(request, "mani-tag -p project2,project4 -c", tmp_path)


def test_clear_tags_all_projects(request, tmp_path):
    check_output(request, "mani-tag -P -c", tmp_path)


def test_sort_tags(request, tmp_path):
    check_output(request, "mani-tag -p project2 -a tag1a,tag2a", tmp_path)


def test_add_one_tag_current_project(request, tmp_path):
    check_output(request, "mani-tag -a fail", tmp_path, "project2")


def test_add_one_tag_current_project_mani_yaml_collision(request, tmp_path):
    check_output(
        request,
        "mani-tag -a fail",
        tmp_path,
        "project1",
    )


def test_concurrency(request, tmp_path):
    check_output(
        request,
        "mani exec -s -o markdown -- mani-tag -a fail",
        tmp_path,
    )
