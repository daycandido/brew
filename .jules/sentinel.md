## 2024-05-18 - Prevent Shell Injection in Package Manager Extensions

**Vulnerability:** Shell injection vulnerabilities exist in multiple `Library/Homebrew/bundle/extensions/*.rb` files due to executing external package manager commands using backticks with string interpolation (e.g., `` `#{npm} list -g ...` ``). Unsanitized input from configuration files could lead to arbitrary command execution.

**Learning:** This repo frequently shells out to external commands. Using backticks (`` `...` ``) directly with interpolation creates potential shell injection attack vectors if the inputs are not properly sanitized or if configuration files are compromised.

**Prevention:** Use `Utils.popen_read` with array arguments instead of backticks when capturing shell command output. Pass the `err: "/dev/null"` keyword argument to `Utils.popen_read` to replicate the `2>/dev/null` behavior of backticks, avoiding parsing bugs while ensuring arguments are correctly escaped. Replace RSpec test mocks expecting backticks with `.to receive(:popen_read)`.
