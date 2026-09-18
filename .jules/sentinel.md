## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-05-24 - Command Injection in Backtick String Interpolation
**Vulnerability:** Using backticks with string interpolation (e.g., `` `#{flatpak} remote-list ...` ``) creates a shell command injection vulnerability if the interpolated variable can be influenced by the user or external sources.
**Learning:** Backticks implicitly pass the entire string to the shell (`/bin/sh`) for evaluation.
**Prevention:** Replace backticks with `Utils.popen_read` and pass the command and its arguments as discrete strings (e.g., `Utils.popen_read(flatpak, "remote-list", ...)`).
