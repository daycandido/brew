## 2024-04-20 - Emphasize critical warnings in terminal output
**Learning:** In command-line interfaces, secondary warning text that follows a primary `opoo` warning often blends into the surrounding output, causing users to miss critical constraints or expected failure messages.
**Action:** Always apply semantic terminal formatting (e.g., `Tty.bold`) to supplementary warning text to ensure it remains distinct and readable alongside the primary colored warning.
