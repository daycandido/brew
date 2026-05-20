## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-05-24 - Avoid select.map
**Learning:** Chaining `.select { ... }.map { ... }`, `.select { ... }.flat_map { ... }`, or `.filter_map(&:m1).map(&:m2)` allocates an intermediate array, which increases garbage collection pressure, particularly when iterating over large collections.
**Action:** Use `.filter_map { ... }` instead, which performs both filtering and mapping in a single pass without intermediate array allocations.
