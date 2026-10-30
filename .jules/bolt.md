## 2025-02-12 - Array allocation optimization in update-report
**Learning:** Chaining `.select { ... }.map { ... }` in Ruby allocates an intermediate array which causes unnecessary memory usage and garbage collection pressure.
**Action:** Use `.filter_map { ... }` when selecting and mapping over enumerables to combine the operations and avoid the intermediate array allocation.
