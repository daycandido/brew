## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-05-24 - Command Injection in Backticks via Interpolation
**Vulnerability:** In `Library/Homebrew/bundle/extensions/vscode_extension.rb`, the command ``` `"#{vscode}" --list-extensions 2>/dev/null` ``` interpolates the `vscode` variable (which holds the executable path from `which`) directly into a string that is passed to the shell via backticks. If a user sets their `PATH` to include a maliciously named executable, this could lead to command injection.
**Learning:** Backticks execute strings via the shell (`/bin/sh`). String interpolation inside backticks or `system "cmd #{var}"` without shell escaping exposes the application to command injection.
**Prevention:** Instead of using backticks with interpolation, use `Utils.popen_read("cmd", "arg", err: "/dev/null")` to pass arguments as an array, completely bypassing the shell.
