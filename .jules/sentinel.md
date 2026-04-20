## 2024-04-20 - Prevent Command Injection with safe_system
**Vulnerability:** Shell command injection risk via string interpolation in system commands.
**Learning:** Using string interpolation with `safe_system` passes the command to `/bin/sh` which is vulnerable to command injection.
**Prevention:** Use array syntax and keyword arguments (e.g. `out: file`) with `safe_system` to bypass the shell and execute directly via `execve`. Variables may need `T.must()` for Sorbet.
