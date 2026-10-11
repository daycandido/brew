## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2026-10-11 - Command injection in uv bundle extension
**Vulnerability:** Shell command injection via interpolated backticks when retrieving uv tool list.
**Learning:** String interpolation within backticks `#{uv} tool list...` executes the string through a shell, exposing arbitrary command execution if the path is attacker-controlled.
**Prevention:** Use array syntax via Utils.popen_read (e.g. `Utils.popen_read(uv.to_s, "tool", "list", ...)`) to execute the command directly, bypassing the shell entirely and preventing command injection.
