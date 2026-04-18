## 2024-05-24 - Prevent Command Injection via String Interpolation in Shell Commands
**Vulnerability:** Shell commands constructed using string interpolation with `safe_system` (e.g., `safe_system "cmd #{var}"`) can lead to command injection if `var` is maliciously crafted or unexpectedly contains shell metacharacters.
**Learning:** Bypassing the shell directly via `execve` using the array syntax for execution and keyword arguments for shell redirects (e.g., `safe_system "cmd", "arg1", out: "filename"`) neutralizes command injection vulnerabilities.
**Prevention:** Always use the `safe_system` array syntax with explicit arguments and kwargs (like `out:`) instead of embedding variables or shell operations (`>`) into single strings.
