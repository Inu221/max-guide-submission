#!/usr/bin/env bash
set -euo pipefail

# max-guide-submission
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

# workspace, где рядом лежат max-guide-submission и max-guide
WORKSPACE_DIR="$(CDPATH= cd -- "$ROOT_DIR/.." && pwd)"

# Репозиторий, который реально сдаём как исходники
SOURCE_ROOT="$WORKSPACE_DIR/max-guide"

# Куда кладём итоговый архив
ARTIFACT_DIR="$ROOT_DIR/artifacts"

ARCHIVE_NAME="max-guide-final-2026-09-30.tar.gz"
ARCHIVE_PATH="$ARTIFACT_DIR/$ARCHIVE_NAME"
CHECKSUM_PATH="$ARTIFACT_DIR/SHA256SUMS.txt"

STAGE_DIR="$(mktemp -d)"
PACKAGE_DIR="$STAGE_DIR/max-guide"

cleanup() {
    rm -rf "$STAGE_DIR"
}
trap cleanup EXIT

echo "==> Source repository:"
echo "    $SOURCE_ROOT"

# Проверяем основной репозиторий
git -C "$SOURCE_ROOT" rev-parse --git-dir >/dev/null 2>&1 || {
    echo "ERROR: $SOURCE_ROOT is not a Git repository" >&2
    exit 1
}

MAIN_COMMIT="$(git -C "$SOURCE_ROOT" rev-parse HEAD)"

echo "==> Main commit:"
echo "    $MAIN_COMMIT"

# Подтягиваем сабмодули на версии, указанные в основном репозитории
echo "==> Updating submodules"
git -C "$SOURCE_ROOT" submodule update --init --recursive

mkdir -p "$ARTIFACT_DIR"
mkdir -p "$PACKAGE_DIR"

# Архивируем основной max-guide
echo "==> Archiving max-guide"

git -C "$SOURCE_ROOT" archive HEAD \
    | tar -xf - -C "$PACKAGE_DIR"

# git archive оставляет для сабмодулей только ссылки,
# поэтому содержимое каждого сабмодуля добавляем отдельно.
echo "==> Archiving submodules"

git -C "$SOURCE_ROOT" config \
    --file "$SOURCE_ROOT/.gitmodules" \
    --get-regexp path |
while read -r _ submodule_path; do

    submodule_commit="$(
        git -C "$SOURCE_ROOT" ls-tree HEAD "$submodule_path" |
        awk '{print $3}'
    )"

    echo "    $submodule_path"
    echo "      commit: $submodule_commit"

    if [ -z "$submodule_commit" ]; then
        echo "ERROR: cannot determine commit for $submodule_path" >&2
        exit 1
    fi

    mkdir -p "$PACKAGE_DIR/$submodule_path"

    # Проверяем наличие нужного commit
    git -C "$SOURCE_ROOT/$submodule_path" \
        cat-file -e "$submodule_commit^{commit}"

    # Кладём содержимое сабмодуля внутрь архива
    git -C "$SOURCE_ROOT/$submodule_path" \
        archive "$submodule_commit" \
        | tar -xf - -C "$PACKAGE_DIR/$submodule_path"
done

echo "==> Creating final archive"

rm -f "$ARCHIVE_PATH" "$CHECKSUM_PATH"

tar -C "$STAGE_DIR" \
    -czf "$ARCHIVE_PATH" \
    max-guide

echo "==> Calculating SHA-256"

(
    cd "$ARTIFACT_DIR"
    sha256sum "$ARCHIVE_NAME" > SHA256SUMS.txt
)

echo
echo "========================================"
echo "DONE"
echo "========================================"
echo
echo "max-guide commit:"
echo "  $MAIN_COMMIT"
echo
echo "Archive:"
echo "  $ARCHIVE_PATH"
echo
echo "SHA-256:"
cat "$CHECKSUM_PATH"
echo
echo "Verify:"
echo "  cd \"$ARTIFACT_DIR\" && sha256sum -c SHA256SUMS.txt"