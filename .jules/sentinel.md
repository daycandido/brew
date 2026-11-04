## 2024-05-18 - Fix command injection risk in VSCode extensions list
**Vulnerability:** Command injection risk due to unsanitized input in backticks execution for VSCode extensions list.
**Learning:** The previous implementation used backticks to execute the VSCode executable, which could allow arbitrary command execution if the path contains shell metacharacters or if WSL_DISTRO_NAME is used improperly.
**Prevention:** Replace backticks execution with Utils.popen_read with explicit arguments array to prevent shell interpretation and properly discard stderr.
