## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.

## 2024-05-20 - Command Injection in Backticks with string interpolation
**Vulnerability:** Calling backticks with a single string containing interpolated variables (e.g., `` `#{kubectl} krew list 2>/dev/null` ``) allows shell command injection.
**Learning:** Backticks execute the string through `/bin/sh`. Using `Utils.popen_read` with a discrete array of arguments bypasses the shell completely. Additionally, to mimic discarding stderr via `2>/dev/null`, use the `err: "/dev/null"` argument.
**Prevention:** Avoid backticks with interpolated paths or arguments. Instead, use `Utils.popen_read` with the array syntax (e.g., `Utils.popen_read(cmd, "arg", err: "/dev/null")`).
