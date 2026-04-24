## 2024-05-30 - Prevent Command Injection in `safe_system` using Array Syntax and `out:`
**Vulnerability:** Shell execution of strings with interpolated variables using `safe_system "cmd #{var} > #{out}"` can lead to command injection if variables are untrusted.
**Learning:** Homebrew's `safe_system` using array syntax (e.g., `safe_system "cmd", "arg"`) executes via `execve` and safely bypasses the shell (`/bin/sh`). Redirection can be handled via keyword arguments like `out: file`. Sorbet may require conditionally initialized variables to be wrapped in `T.must(...)`.
**Prevention:** Always refactor string-based `safe_system` calls with variable interpolation into the array form. Redirect output natively using the `out:` keyword argument instead of shell `>`.
