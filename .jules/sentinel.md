## 2024-05-30 - Fix command injection risk in krew extension
**Vulnerability:** Command injection risk via unsanitized input to shell command using backticks (`#{kubectl} krew list 2>/dev/null`).
**Learning:** Backticks execute strings through a subshell, making them vulnerable if `kubectl` path or args contain unexpected characters.
**Prevention:** Use `Utils.popen_read` with explicit arguments array instead of backticks to prevent shell injection, passing `err: "/dev/null"` to retain the original behavior.
## 2024-05-30 - Fix command injection risk in krew extension
**Vulnerability:** Command injection risk via unsanitized input to shell command using backticks (`#{kubectl} krew list 2>/dev/null`).
**Learning:** Backticks execute strings through a subshell, making them vulnerable if `kubectl` path or args contain unexpected characters.
**Prevention:** Use `Utils.popen_read` with explicit arguments array instead of backticks to prevent shell injection, passing `err: "/dev/null"` to retain the original behavior.
## 2024-05-30 - Fix command injection risk in krew extension
**Vulnerability:** Command injection risk via unsanitized input to shell command using backticks (`#{kubectl} krew list 2>/dev/null`).
**Learning:** Backticks execute strings through a subshell, making them vulnerable if `kubectl` path or args contain unexpected characters.
**Prevention:** Use `Utils.popen_read` with explicit arguments array instead of backticks to prevent shell injection, passing `err: "/dev/null"` to retain the original behavior.
