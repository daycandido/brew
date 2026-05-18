## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2026-05-18 - Corrupted arguments via Shellwords.escape in array-based command execution
**Vulnerability:** Applying `Shellwords.escape` to arguments that are subsequently passed as an array to `Open3.popen2e` (or similar methods like `system`) corrupts the inputs by injecting literal backslashes.
**Learning:** When executing commands via `Open3.popen2e` using an array of arguments, the shell is bypassed completely, and arguments are passed literally. Escaping them adds literal escape characters that can corrupt arguments and introduce parsing vulnerabilities or bugs.
**Prevention:** Never use `Shellwords.escape` when passing arguments as an array to `Open3.popen2e` or `system`.
