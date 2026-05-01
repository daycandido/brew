## 2024-05-15 - Improve multiline warnings
**Learning:** Found instances of multiline warnings formatted inconsistently with `opoo` for the first line and `puts` for the second line. This is poor UX for terminal outputs because `opoo` typically provides formatting (like a "Warning:" prefix and yellow text) while `puts` outputs plain text, which breaks the visual styling of a warning message.
**Action:** Use a heredoc with `opoo <<~EOS` to encapsulate the entire message within the warning semantic block and improve the overall CLI UX.
