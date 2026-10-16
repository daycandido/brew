## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.

## 2025-03-05 - Command injection in go bundle extension
**Vulnerability:** Command injection in go bundle extension via string interpolation in backticks.
**Learning:** Using backticks with string interpolation for external shell commands (like `#{go} version -m "#{binary}"`) is dangerous when `binary` comes from untrusted directories. It opens up the application to command injection vulnerabilities. `Utils.popen_read` with separate arguments safely passes arguments without shell interpretation.
**Prevention:** Use `Utils.popen_read` or `system` with separate array arguments rather than backtick execution with interpolated strings.
