## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-05-18 - Hardcoded API Key in Analytics
**Vulnerability:** A hardcoded `INFLUX_TOKEN` was present in `Library/Homebrew/utils/analytics.rb`.
**Learning:** Hardcoded credentials in source control, even for scoped write-only analytics, are a security risk as they can be extracted and misused by attackers.
**Prevention:** Always load secrets from environment variables (e.g., `ENV.fetch`) or secure credential stores instead of hardcoding them in the codebase.
