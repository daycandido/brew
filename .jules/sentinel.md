## 2026-10-24 - Prevent potential command injection in VSCode extension bundle command
**Vulnerability:** The vscode extension bundle command uses string interpolation with shell backticks `"#{vscode}" --list-extensions 2>/dev/null` where `vscode` comes from a local executable path that might be manipulatable or vulnerable if it contains shell metacharacters.
**Learning:** In Ruby CLI apps, string interpolation in backticks passes the string to a shell, making it susceptible to injection or syntax errors if the variable contains unescaped characters.
**Prevention:** Replace backticks with `Utils.popen_read(cmd, arg)` which bypasses the shell and executes the command with arguments as an array.
