# Using Recap

1. Open a book that has recap data embedded (see README).
2. Tap the page to show the reading bar, then tap the **Recap** button.
3. Read the recap. Page through with the dialog's arrows; the cast list is on
   the following pages. Close the dialog to return to your book.

## What you'll see

- **"Last read N day(s) ago"** — from the book's last-read date.
- **"You stopped after …"** — the last chapter you finished, summarised.
  If you are partway through a chapter, a line says so; that chapter is never
  summarised, because its summary would give away the rest of it.
- **"Before that, …"** — the chapter before, for context.
- **"Who you have met"** — up to 30 people, ranked by how often they have
  appeared so far.

## Messages

- **"This book has no recap data embedded yet."** — the book carries no
  `EPUB/recaps/recaps.tsv`. Recaps are generated on a computer and embedded
  before the book goes onto the Kobo.
- **"You are at the very beginning, so there is nothing to recap."** — you
  haven't finished a chapter yet.
- **"No sqlite3 available."** — install NickelHardcover, or put a `sqlite3`
  binary in `.adds/Recap/`.

## Books from Grimmory and other servers

Books synced from a server work the same as sideloaded ones. They live in
`.kobo/kepub/` under an ID instead of a filename, and Recap finds them there
automatically.
