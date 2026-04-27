## 2024-05-18 - Improve multiline warnings in CLI output
**Learning:** Multiline warning messages consisting of `opoo "message"` followed by `puts "sub-message"` break the semantic structure of the output since only the first line is colored/labeled as a warning.
**Action:** When emitting multiline warnings, combine them into a single string using a heredoc (`<<~EOS`) so the entire block is styled properly as a warning.
