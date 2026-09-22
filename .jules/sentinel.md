## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-05-24 - Command Injection in string interpolation in bundle extension
**Vulnerability:** In `vscode_extension.rb`, calling `` `"#{vscode}" --list-extensions 2>/dev/null` `` allowed shell command injection if the executable path contained malicious characters.
**Learning:** Backticks `` `cmd` `` execute through the shell (`/bin/sh`), making them vulnerable to command injection via string interpolation, especially when variables can be influenced by attackers (e.g. `package_manager_executable`).
**Prevention:** Use `Utils.popen_read` with array arguments to pass commands directly to `execve`, bypassing the shell. Use `err: "/dev/null"` to retain the behavior of discarding stderr without shell operators like `2>/dev/null`.
