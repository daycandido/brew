## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2026-06-06 - Corrupting array arguments with Shellwords.escape
**Vulnerability:** Escaping array arguments with `Shellwords.escape` before passing them to `Open3.popen2e` (or `system`, `exec`) adds literal backslashes to the arguments, corrupting them and potentially allowing command injection or unexpected behavior if the underlying command misinterprets the backslashes.
**Learning:** The array-argument form of commands like `Open3.popen2e(cmd, *args)` bypasses the shell completely and passes arguments exactly as provided. Applying `Shellwords.escape` on these arguments is unnecessary and harmful because it introduces backslashes that are meant for shell parsing, not for literal arguments.
**Prevention:** Never use `Shellwords.escape` on individual array elements passed to commands that bypass the shell (like `Open3.popen2e(cmd, *args)`).
