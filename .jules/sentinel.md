## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-05-18 - Command Injection in string interpolation in vscode extension bundle
**Vulnerability:** Calling backticks with a single string containing interpolated variables (e.g., `` `#{vscode} --list-extensions 2>/dev/null` ``) allows shell command injection.
**Learning:** Interpolated variables are evaluated by the shell (`/bin/sh`). If `vscode` is attacker-controlled or maliciously named, arbitrary commands could be executed.
**Prevention:** Always use the array syntax via `Utils.popen_read` (e.g., `Utils.popen_read(vscode.to_s, "--list-extensions", err: "/dev/null")`) which bypasses the shell completely and prevents command injection. Use `err: "/dev/null"` to replicate `2>/dev/null` behavior.
