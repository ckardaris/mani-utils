from pathlib import Path

docs = Path(__file__).parent.parent.parent / "docs"


def test_mani_tag_help():
    doc = docs / "mani-tag.md"
    assert doc.is_file()
    assert (
        """
USAGE:
  mani-tag [OPTIONS]

OPTIONS:
  -p project1,project2,...    Select project (default: current directory)
  -P                          Select all projects
  -a tag1,tag2,...            Add tags to projects
  -d tag1,tag2,...            Delete tags from projects
  -c                          Clear all tags for projects
  -h                          Show this help message
"""
        in doc.read_text()
    )


def test_mani_init_help():
    doc = docs / "mani-init.md"
    assert doc.is_file()
    assert (
        """
USAGE:
  mani-init [OPTIONS]

OPTIONS:
  -f file1,file2,...          Select file to create project from
                              (default: .git)
  -n CMD                      Run command on project directory to assign a name
                              (default: relative path from 'mani.yaml').
  -s                          Sync existing 'mani.yaml' with additional projects.
  -h                          Show this help message
"""
        in doc.read_text()
    )
