## 2024-05-25 - Fix Command Injection in NPM Extension
**Vulnerability:** Shell execution with string interpolation (`#{npm} list ...`) allows command injection via crafted paths/arguments
**Learning:** Backticks (`...`) with interpolation are unsafe when processing variables, even local binaries, as paths can contain malicious metacharacters
**Prevention:** Use `Utils.popen_read` with separate arguments (e.g. `Utils.popen_read(npm.to_s, "list", ...)`) to bypass the shell entirely and safely handle arbitrary paths
