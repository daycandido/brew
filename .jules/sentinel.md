## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.

## 2024-04-24 - Command Injection in Backticks with string interpolation
**Vulnerability:** Calling backticks with a string containing interpolated variables (e.g., `\`#{cmd} arg\``) allows shell command injection.
**Learning:** `\`#{cmd} arg\`` passes the entire string to the shell. If `cmd` or `arg` is attacker-controlled, they can run arbitrary commands. Backticks cannot bypass the shell execution.
**Prevention:** Always use `Utils.popen_read` with array syntax (e.g., `Utils.popen_read(cmd, "arg")`) which bypasses the shell completely and prevents command injection. When replacing `\`... 2>/dev/null\``, pass the `err: :close` option.
