## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-24 - Avoid select.map and select.flat_map
**Learning:** Chaining `.select` and `.map` (or `.flat_map`) evaluates the entire collection multiple times and allocates intermediate arrays, increasing garbage collection pressure.
**Action:** Use `.filter_map` instead to combine filtering and mapping into a single pass, avoiding intermediate array allocations.
