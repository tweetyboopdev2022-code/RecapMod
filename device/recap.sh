#!/bin/sh
# Recap - what you read last time, for Nickel's reader menu.
#
# Reads the recap data embedded in the kepub itself (EPUB/recaps/*.tsv) and
# your position from KoboReader.sqlite, and shows only what is at or before
# where you are.
#
# Rows are keyed by SPINE FILENAME, not by a number. Nickel's VolumeIndex
# counts every spine document including the title page, while the generator
# only ever saw the chapter files, so the two numberings differ by however
# much front matter a book has. Matching the filename removes that offset.
#
# Output is HTML for a QLabel. A line containing only <!--PAGE--> starts a new
# page in the dialog.

DB=${RECAP_DB:-/mnt/onboard/.kobo/KoboReader.sqlite}
MAXCAST=30
HALFLINES=30
LINECOLS=58
MAXSUMMARY=600

SQL=""
for c in /mnt/onboard/.adds/NickelHardcover/sqlite3 /mnt/onboard/.adds/Recap/sqlite3; do
    [ -x "$c" ] && SQL="$c" && break
done
[ -z "$SQL" ] && SQL=$(command -v sqlite3 2>/dev/null)
[ -z "$SQL" ] && { echo "No sqlite3 available. Nothing was read or changed."; exit 0; }

q() { "$SQL" "$DB" "$1" 2>/dev/null; }
esc() { printf '%s' "$1" | sed "s/'/''/g"; }
html() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; }

clip() {
    awk -v m="$MAXSUMMARY" '{
        if (length($0) <= m) { print; next }
        s = substr($0, 1, m)
        p = match(s, /.*[.!?] /)
        if (RSTART > 0 && RLENGTH > m/2) print substr(s, 1, RLENGTH)
        else print s "..."
    }'
}

# $1 is the ContentID the mod read out of Nickel. The DateLastRead fallback is
# one book behind, because the row is only written when a book is closed.
BOOK="${1:-}"
[ -z "$BOOK" ] && BOOK=$(q "SELECT ContentID FROM content WHERE ContentType=6 AND DateLastRead IS NOT NULL ORDER BY DateLastRead DESC LIMIT 1;")
[ -z "$BOOK" ] && { echo "No recently read book found."; exit 0; }
BQ=$(esc "$BOOK")

TITLE=$(q "SELECT Title FROM content WHERE ContentID='$BQ';")
GAP=$(q "SELECT CAST(julianday('now') - julianday(DateLastRead) AS INT) FROM content WHERE ContentID='$BQ';")
MARK=$(q "SELECT ChapterIDBookmarked FROM content WHERE ContentID='$BQ';")
FRAG=$(printf '%s' "$MARK" | sed 's/.*!//; s/#.*//')
SPAN=$(printf '%s' "$MARK" | sed -n 's/.*#kobo\.\([0-9][0-9]*\)\..*/\1/p')

PATHNAME=$(printf '%s' "$BOOK" | sed 's|^file://||')
SRC=""
for cand in "$PATHNAME" \
            "$(printf '%s' "$PATHNAME" | sed 's/\.kepub\.epub$/_with_ai_recaps.kepub.epub/')" \
            "$(printf '%s' "$PATHNAME" | sed 's/\.kepub\.epub$/_with_recaps.kepub.epub/')"; do
    [ -f "$cand" ] || continue
    if unzip -l "$cand" 2>/dev/null | grep -q "EPUB/recaps/recaps.tsv"; then
        SRC="$cand"
        break
    fi
done
[ -n "$RECAP_SRC" ] && SRC="$RECAP_SRC"
[ -z "$SRC" ] && { printf '<p><b>%s</b></p><p>This book has no recap data embedded yet.</p>\n' "$(printf '%s' "$TITLE" | html)"; exit 0; }

RECAPS=$(unzip -p "$SRC" EPUB/recaps/recaps.tsv 2>/dev/null)

# Where you are. An exact filename match means you are inside that chapter, so
# the recap has to stop before it. No match means front matter or a chapter too
# short to summarise, and the last chapter before it is the right one.
CUR=$(printf '%s\n' "$RECAPS" | awk -F'\t' -v f="$FRAG" '$2==f {print $1; exit}')
INSIDE=""
if [ -n "$CUR" ]; then
    # How far into the current chapter you are. Kobo numbers every paragraph
    # span, so the bookmark's span against the chapter's total is real
    # progress. Below the threshold the chapter counts as unread, and that
    # governs the cast as well as the recap: listing everyone who appears in a
    # chapter you are halfway through is exactly the spoiler this avoids.
    TOTAL=$(unzip -p "$SRC" "$FRAG" 2>/dev/null \
            | grep -o 'id="kobo\.[0-9]*\.' | sort -u | wc -l | tr -d ' ')
    PCT=0
    if [ -n "$SPAN" ] && [ "${TOTAL:-0}" -gt 0 ] 2>/dev/null; then
        PCT=$(( SPAN * 100 / TOTAL ))
    fi
    if [ "$PCT" -ge 90 ] 2>/dev/null; then
        RECAPTO=$CUR
    else
        RECAPTO=$((CUR - 1))
        INSIDE=yes
    fi
else
    CUR=$(printf '%s\n' "$RECAPS" | awk -F'\t' -v f="$FRAG" '$2"" < f"" {p=$1} END{print (p=="" ? -1 : p)}')
    RECAPTO=$CUR
fi
CASTTO=$RECAPTO

if [ "$GAP" -gt 0 ] 2>/dev/null; then
    WHEN="Last read $GAP day(s) ago"
else
    WHEN="Last read today"
fi

pick() {
    printf '%s\n' "$RECAPS" | awk -F'\t' -v n="$1" -v f="$2" '$1+0<=n {v=$f} END{print v}'
}

LABEL=$(pick "$RECAPTO" 3)
SUMMARY=$(pick "$RECAPTO" 4 | clip | html)
PREVTO=$(printf '%s\n' "$RECAPS" | awk -F'\t' -v n="$RECAPTO" '$1+0<n {p=$1} END{print (p=="" ? -1 : p)}')
PLABEL=$(pick "$PREVTO" 3)
PSUMMARY=$(pick "$PREVTO" 4 | clip | html)

SANS='font-family:sans-serif'

printf '<p style="%s; font-size:68%%; color:#666666; margin:0px 0px 12px 0px">%s</p>' \
    "$SANS" "$(printf '%s' "$WHEN" | tr '[:lower:]' '[:upper:]')"
if [ -n "$SUMMARY" ]; then
    printf '<p style="%s; font-size:124%%; margin:0px"><b>You stopped after %s</b></p>' \
        "$SANS" "$(printf '%s' "$LABEL" | html)"
    if [ -n "$INSIDE" ]; then
        printf '<p style="font-size:84%%; color:#666666; margin:5px 0px 0px 0px">You are partway through %s.</p>' \
            "$(pick "$CUR" 3 | html)"
    fi
    printf '<hr>'
    printf '<p style="margin:0px; line-height:152%%">%s</p>' "$SUMMARY"
    if [ -n "$PSUMMARY" ]; then
        # The summary page had no budget of its own, so a second chapter simply
        # ran off the bottom. Give it its own page when it will not fit.
        USED=$(( 6 + 2 * ((${#SUMMARY} + 57) / 58) ))
        NEED=$(( 3 + 2 * ((${#PSUMMARY} + 64) / 65) ))
        if [ $((USED + NEED)) -gt "$HALFLINES" ]; then
            printf '\n<!--PAGE-->\n'
            printf '<p style="%s; font-size:68%%; color:#666666; margin:0px 0px 12px 0px">BEFORE THAT</p>' "$SANS"
            printf '<p style="%s; font-size:124%%; margin:0px"><b>%s</b></p>' \
                "$SANS" "$(printf '%s' "$PLABEL" | html)"
            printf '<hr>'
            printf '<p style="margin:0px; line-height:152%%">%s</p>' "$PSUMMARY"
        else
            printf '<p style="%s; font-size:84%%; margin:36px 0px 10px 0px"><b>Before that, %s</b></p>' \
                "$SANS" "$(printf '%s' "$PLABEL" | html)"
            printf '<p style="font-size:89%%; color:#555555; margin:0px; line-height:152%%">%s</p>' "$PSUMMARY"
        fi
    fi
else
    printf '<p style="%s; font-size:124%%; margin:0px"><b>%s</b></p>' \
        "$SANS" "$(printf '%s' "$TITLE" | html)"
    printf '<p style="margin-top:12px">You are at the very beginning, so there is nothing to recap.</p>'
fi

# One row per person, first-appearance order, most recent description at or
# before your position, most recently met shown first.
# Ranked by how many chapters the person appears in, not by who was met
# most recently. Recency buried the leads: by chapter 13 of Harry Potter 5,
# Harry ranked 81st of 83 and fell off a 30-name list entirely.
CAST=$(unzip -p "$SRC" EPUB/recaps/cast.tsv 2>/dev/null \
       | awk -F'\t' -v n="$CASTTO" '
         function clean(t,   low, p) {
             low = tolower(t)
             if (low !~ FATE) return t
             p = index(low, " who ")
             if (p < 2) p = index(low, ", ")
             if (p < 2) return ""
             t = substr(t, 1, p - 1)
             sub(/[ ,]+$/, "", t)
             if (tolower(t) ~ FATE) return ""
             return t
         }
         BEGIN {
             FATE = "kill|dies|died|dead|murder|betray|traitor|reveal|turns out|secretly|is actually|later becomes|will be|survives|sacrific|tortur|madness|insane|imprison|executed|doomed|his fate|her fate|their fate"
         }
         $1+0<=n {
             if (!($3 in seen)) order[++c] = $3
             seen[$3]++
             t = clean($4)
             sub(/^members of/, "a member of", t)
             if (t != "" && $1+0 >= last[$3]) { last[$3] = $1+0; d[$3] = t }
         }
         END {
             for (i = 1; i <= c; i++) {
                 nm = order[i]
                 printf "%d\t%s\t%s\n", seen[nm] * 1000 + last[nm], nm,
                        (nm in d ? d[nm] : "")
             }
         }' | sort -rn | cut -f2-)
COUNT=$(printf '%s\n' "$CAST" | grep -c .)
[ "$COUNT" -eq 0 ] 2>/dev/null && exit 0

printf '\n<!--PAGE-->\n'
printf '<p style="%s; font-size:68%%; color:#666666; margin:0px 0px 16px 0px">WHO YOU HAVE MET (%s)</p>' \
    "$SANS" "$COUNT"
printf '%s\n' "$CAST" | head -n "$MAXCAST" | html \
    | awk -F'\t' -v budget="$HALFLINES" -v w="$LINECOLS" \
          -v total="$COUNT" -v shown="$MAXCAST" '
        function rows(t,   k) { k = int((length(t) + w - 1) / w); return k < 1 ? 1 : k }
        BEGIN { used = 5; pending = 0 }
        {
            cost = 2 * rows($1 "  " $2) + 1
            if (used + cost > budget) {
                print ""
                print "<!--PAGE-->"
                used = 0
                pending = 0
            }
            if (pending) print "<hr>"
            printf "<p style=\"margin:0px 0px 12px 0px; line-height:148%%\"><b style=\"font-family:sans-serif; font-size:92%%\">%s</b>&nbsp;&nbsp;%s</p>\n", $1, $2
            pending = 1
            used += cost
        }
        END {
            if (total > shown)
                printf "<p style=\"margin-top:18px\">Most recently met %d of %d.</p>", shown, total
        }'
