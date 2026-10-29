
## 2025-05-18 - Replacing Unsafe Command Execution via Backticks
**Vulnerability:** Use of backticks (`` `...` ``) for shell command execution without escaping, leading to potential command injection or unexpected execution.
**Learning:** Using backticks evaluates expressions in a shell context where argument values (even string interpolation of variables like paths) can trigger undesired side effects if they contain shell metacharacters. Specifically, when we construct command arrays manually using string interpolation inside backticks instead of an array-based popen method, we bypass Ruby's safe argument passing to `execve`.
**Prevention:** Always use `Utils.popen_read` (or `Utils.safe_popen_read` when a non-zero exit code should raise an error) and pass arguments as an array rather than constructing a single shell string. When replacing shell pipelines or redirects (like `2>/dev/null`), pass `err: "/dev/null"` to `Utils.popen_read`.
