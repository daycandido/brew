## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.

## 2024-05-18 - Command Injection in bundle extensions with string interpolation
**Vulnerability:** Shell command injections when using string interpolation in backticks (e.g. `` `#{go} env GOBIN` ``). This passes the entire string to the shell which could evaluate attacker-controlled parameters.
**Learning:** Even internal or path variables used with backticks inside extensions (like `bundle/extensions/go.rb`) are evaluated by the shell and can lead to command injection.
**Prevention:** Use array syntax with `Utils.popen_read` (e.g. `Utils.popen_read(go.to_s, "env", "GOBIN")`) to bypass the shell and execute commands safely.
