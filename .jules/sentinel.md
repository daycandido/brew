## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-06-01 - Command Injection in backticks string interpolation
**Vulnerability:** Executing shell commands using string interpolation within backticks (e.g. \`cmd #{var}\`) allows shell command injection if `var` is attacker-controlled.
**Learning:** Using backticks passes the entire string to `/bin/sh`. Even if `var` is a file path read from the filesystem, it can be named maliciously to execute arbitrary commands.
**Prevention:** To securely execute a command, capture its stdout, and avoid raising exceptions, use `Utils.popen_read("cmd", var)` with array arguments which bypasses the shell completely.
