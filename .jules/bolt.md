## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-05-01 - Avoid Array Allocation in Chained select.map

**Learning:** Chaining `.select { ... }.map { ... }` or `.select(&:...).map` evaluates the entire collection, creates an intermediate array for the selected items, and then iterates over that intermediate array to map the values, increasing garbage collection pressure.

**Action:** Use `.filter_map { ... }` instead, which performs both operations in a single pass without allocating an intermediate array.
