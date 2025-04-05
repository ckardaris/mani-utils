#!/usr/bin/env bash

set -e
set -o pipefail

function make_doc()
{
    title="$1"
    exe="bin/$1"
    doc="$2"
    top_file=$(mktemp -u)
    require_file=$(mktemp -u)
    help_file=$(mktemp -u)
    bottom_file=$(mktemp -u)

    help="$(awk '/# HELP_BEGIN/{flag=1; next} /# HELP_END/{flag=0} flag' "$exe" | sed 's:\ *echo\ *::' | sed 's:.*"\(.*\)":\1:')\n"

    sed '1,/<!-- REQUIRE_BEGIN/!d;' "$doc" | head -n -1 > "$top_file"

    echo "<!-- REQUIRE_BEGIN - AUTOMATICALLY GENERATED -->" >> "$require_file"
    echo "### Requirements" >> "$require_file"
    grep "^requirement" "$exe" | sed "s:requirement\ *\(.*\):- \`\1\`:" >> "$require_file"
    echo "<!-- REQUIRE_END - AUTOMATICALLY GENERATED -->" >> "$require_file"

    echo "<!-- USAGE_BEGIN - AUTOMATICALLY GENERATED -->" >> "$help_file"
    echo "### Usage" >> "$help_file"
    echo "\`\`\` bash" >> "$help_file"
    printf "$help" >> "$help_file"
    echo "\`\`\`" >> "$help_file"
    echo "<!-- USAGE_END - AUTOMATICALLY GENERATED -->" >> "$help_file"

    sed '/<!-- USAGE_END/,// !d' "$doc" | tail -n +2 > "$bottom_file"

    cat \
        "$top_file" \
        "$require_file" \
        "$help_file" \
        "$bottom_file" \
        > "$doc"

    rm -f \
        "$top_file" \
        "$require_file" \
        "$help_file" \
        "$bottom_file"
}

make_doc mani-tag docs/mani-tag.md
make_doc mani-init docs/mani-init.md
