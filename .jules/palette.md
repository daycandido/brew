## 2025-02-05 - Multiline warning styling
**Learning:** When outputting warnings in the CLI, multiple sequential output commands (like \`opoo\` followed by \`$stderr.puts\`) will not group the lines semantically as a single warning block.
**Action:** When emitting multiline warnings in CLI output, combine them into a single string using a heredoc (e.g., \`opoo <<~EOS\`) rather than using \`opoo\` for the first line and \`puts\` for subsequent lines. This ensures the entire block is semantically styled as a warning.
