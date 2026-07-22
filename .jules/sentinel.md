## 2026-06-18 - Fix command injection in VSCode extension
**Vulnerability:** Command injection vulnerability due to string interpolation in backticks (` `"#{vscode}" ...` `).
**Learning:** Using backticks with interpolation allows arbitrary command execution if the interpolated variable can be controlled by an attacker.
**Prevention:** Use `Utils.popen_read` with arguments passed as an array to bypass the shell.
