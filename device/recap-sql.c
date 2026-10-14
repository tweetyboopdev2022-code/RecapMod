/* recap-sql: minimal read-only query tool for Recap.
 * usage: recap-sql DB SQL
 * Prints rows like the sqlite3 shell's default mode: columns joined by '|',
 * NULL as empty, one row per line. Exits 1 with the error on stderr. */
#include <stdio.h>
#include "sqlite3.h"

static int row(void *u, int n, char **v, char **c) {
    (void)u; (void)c;
    for (int i = 0; i < n; i++) {
        if (i) fputc('|', stdout);
        if (v[i]) fputs(v[i], stdout);
    }
    fputc('\n', stdout);
    return 0;
}

int main(int argc, char **argv) {
    sqlite3 *db;
    char *err = NULL;
    if (argc != 3) { fprintf(stderr, "usage: %s DB SQL\n", argv[0]); return 2; }
    if (sqlite3_open_v2(argv[1], &db, SQLITE_OPEN_READONLY, NULL) != SQLITE_OK) {
        fprintf(stderr, "open %s: %s\n", argv[1], sqlite3_errmsg(db));
        return 1;
    }
    sqlite3_busy_timeout(db, 3000);
    if (sqlite3_exec(db, argv[2], row, NULL, &err) != SQLITE_OK) {
        fprintf(stderr, "query: %s\n", err ? err : sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }
    sqlite3_close(db);
    return 0;
}
