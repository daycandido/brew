## 2024-05-07 - Consolidate Multi-line Warnings
**Learning:** Emitting a warning with `opoo` and subsequent lines with `puts` results in a fragmented visual experience where the warning color/styling is only applied to the first line. In Homebrew, this is a recurring issue when notifying users that building from source is unsupported.
**Action:** When emitting multiline warnings, always combine them into a single string using a heredoc (e.g., `opoo <<~EOS`) to ensure the entire block is semantically styled as a warning, improving CLI accessibility and visual consistency.
