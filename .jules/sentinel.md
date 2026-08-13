## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-06-25 - Command Injection in Flatpak Extension via String Interpolation
**Vulnerability:** Calling backticks with interpolated paths like `` `#{flatpak} remote-list ...` `` passes the string directly to a subshell (`/bin/sh`), allowing command injection if the executable path contains shell metacharacters.
**Learning:** Ruby's backtick syntax always uses a shell to execute the command when string interpolation is used. This is unsafe.
**Prevention:** Use `Utils.popen_read` with array arguments to safely execute the command by bypassing the shell. Additionally, use `err: :close` to safely suppress standard error output instead of appending `2>/dev/null` in the command string.
