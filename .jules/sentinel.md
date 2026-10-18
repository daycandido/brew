## 2025-02-28 - Replace 2>/dev/null with Utils.popen_read
**Vulnerability:** Use of backticks with 2>/dev/null discards standard error and can lead to unhandled shell expansion or command injection vulnerabilities if inputs are not properly sanitized.
**Learning:** Command injection and shell vulnerabilities are a significant security risk in system commands. Replacing backticks with safe utilities like Utils.popen_read with proper stderr handling is safer and prevents command injection.
**Prevention:** Use Utils.popen_read and ensure standard error is properly configured instead of using raw backticks and shell redirection.
## 2025-02-28 - Replace 2>/dev/null with Utils.popen_read
**Vulnerability:** Use of backticks with 2>/dev/null discards standard error and can lead to unhandled shell expansion or command injection vulnerabilities if inputs are not properly sanitized.
**Learning:** Command injection and shell vulnerabilities are a significant security risk in system commands. Replacing backticks with safe utilities like Utils.popen_read with proper stderr handling is safer and prevents command injection.
**Prevention:** Use Utils.popen_read and ensure standard error is properly configured instead of using raw backticks and shell redirection.
