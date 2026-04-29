## 2024-04-29 - Improve visibility of multiline CLI warnings
**Learning:** Multiline warnings printed line by line using `opoo` followed by `puts` result in unstyled, easily missed text for all lines after the first. A heredoc combined with `opoo` ensures the entire block is semantically styled as a warning, improving readability and drawing the user's attention.
**Action:** When creating or modifying multiline warnings in the CLI output, combine them into a single string using a heredoc and pass it to `opoo`.
