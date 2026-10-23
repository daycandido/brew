## 2024-05-18 - Prevent Command Injection in Krew Extension
**Vulnerability:** Command injection vulnerability in `Library/Homebrew/bundle/extensions/krew.rb` where `kubectl` (which can be derived from user environment variables) was passed via string interpolation to backticks (``).
**Learning:** Backticks (``) use the shell and are vulnerable to command injection if paths or arguments contain shell metacharacters or are user-controlled.
**Prevention:** Use `Utils.popen_read` with discrete array arguments instead of backticks to bypass the shell when executing commands.
## 2026-10-23 - Prevent Command Injection in Krew Extension
**Vulnerability:** Command injection vulnerability in `Library/Homebrew/bundle/extensions/krew.rb` where `kubectl` (which can be derived from user environment variables) was passed via string interpolation to backticks (``)
**Learning:** Backticks (``) use the shell and are vulnerable to command injection if paths or arguments contain shell metacharacters or are user-controlled.
**Prevention:** Use `Utils.popen_read` with discrete array arguments instead of backticks to bypass the shell when executing commands.
