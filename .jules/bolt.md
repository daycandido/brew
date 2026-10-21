## 2024-10-25 - Avoid array allocations with short-circuiting Enumerable methods
**Learning:** Chaining .map(&:property).any? allocates an intermediate array.
**Action:** Use .any?(&:property) to short-circuit evaluation and reduce garbage collection pressure.
