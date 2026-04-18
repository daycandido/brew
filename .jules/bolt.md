## 2024-04-18 - Avoid ||= for nil-returning methods
**Learning:** `||=` does not memoize `nil` or `false` values, causing redundant re-evaluation. For expensive methods returning nil/false (e.g., `which`), this leads to unnecessary executions on every method call.
**Action:** Use `return @var if defined?(@var)` for memoization.
