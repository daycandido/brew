## 2025-02-27 - Command Injection via Backticks
**Vulnerability:** Use of backticks to execute shell commands with untrusted user input without sanitization (`#{vscode}` and others).
**Learning:** Ruby's backticks implicitly invoke the shell and thus enable shell command injection if the interpolated variables are attacker controlled.
**Prevention:** Always use `Utils.popen_read` with command arguments passed as a discrete array instead of a string, or `Kernel.system` with discrete array arguments.
