#!/bin/sh
# Generate rekeyvacuum.c from SQLite3 amalgamation and write it to stdout.
# Usage: ./script/rekeyvacuum.sh sqlite3.c >rekeyvacuum.c

INPUT="$([ "$#" -eq 1 ] && echo "$1" || echo "sqlite3.c")"
if ! [ -f "$INPUT" ]; then
  echo "Usage: $0 <SQLITE3_AMALGAMATION>" >&2
  echo " e.g.: $0 sqlite3.c" >&2
  exit 1
fi

die() {
    echo "[-]" "$@" >&2
    exit 2
}

VERSION="$(sed -n 's/^#define SQLITE_VERSION[^"]*"\([0-9]\+\.[0-9]\+\.[0-9]\+\)"$/\1/p' "$INPUT")"
[ -z "$VERSION" ] && die "cannot find SQLite3 version (is '$INPUT' a valid amalgamation?)"

cat <<EOF
/*
** 2020-11-14
**
** The author disclaims copyright to this source code.  In place of
** a legal notice, here is a blessing:
**
**    May you do good and not evil.
**    May you find forgiveness for yourself and forgive others.
**    May you share freely, never taking more than you give.
**
************************************************************************
**
** This file contains an adjusted version of function sqlite3RunVacuum
** to allow reducing or removing reserved page space.
** For this purpose the number of reserved bytes per page for the target
** database is passed as an extra parameter to the adjusted function.
**
** NOTE: When upgrading to a new version of SQLite3 it is strongly
** recommended to check the original function sqlite3RunVacuum of the
** new version for relevant changes, and to incorporate them in the
** adjusted function below.
**
** Change 0: Rename function to sqlite3mcRunVacuumForRekey()
** Change 1: Add parameter 'int nRes'
** Change 2: Remove local variable 'int nRes'
** Change 3: Remove initialization 'nRes = sqlite3BtreeGetOptimalReserve(pMain)'
** Change 4: Call sqlite3mcBtreeSetPageSize instead of sqlite3BtreeSetPageSize for main database
**           (sqlite3mcBtreeSetPageSize allows to reduce the number of reserved bytes)
**
** This code is generated by the script rekeyvacuum.sh from SQLite version $VERSION amalgamation.
*/
EOF
sed -n '/^SQLITE_PRIVATE .*int sqlite3RunVacuum([^;]*$/,/^}$/p' "$INPUT" \
    | sed 's/sqlite3RunVacuum/sqlite3mcRunVacuumForRekey/' \
    | sed 's/rc = sqlite3BtreeSetPageSize/rc = sqlite3mcBtreeSetPageSize/' \
    | sed 's/^\([^ )][^)]*\)\?){$/\1, int nRes){/' \
    | sed '/nRes = /i \\n  \/\* A VACUUM cannot change the pagesize of an encrypted database. \*\/\n  if( db->nextPagesize ){\n    extern void sqlite3mcCodecGetKey(sqlite3*, int, void**, int*);\n    int nKey;\n    char *zKey;\n    sqlite3mcCodecGetKey(db, iDb, (void**)&zKey, &nKey);\n    if( nKey ) db->nextPagesize = 0;\n  }' \
    | grep -v "int nRes;\|nRes = " \
    | grep "^" || die "Error generating rekeyvacuum.c"