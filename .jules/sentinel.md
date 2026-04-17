## 2025-01-16 - safe_system command injection via shell interpolation
**Vulnerability:** Command injection when using `safe_system "command > #{file}"`.
**Learning:** Single-string arguments to `safe_system` execute via `/bin/sh` and evaluate interpolated variables as shell input.
**Prevention:** Use array arguments and output redirection kwargs (`safe_system "cmd", "arg", out: file`) to bypass the shell via `execve`.
