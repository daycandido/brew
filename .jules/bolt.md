## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-06-11 - Avoid map.select.map
**Learning:** Using `.map { ... }.select { ... }.map { ... }` or similar chained methods evaluates the collection multiple times and allocates multiple intermediate arrays, increasing garbage collection pressure.
**Action:** Use `.filter_map { ... }` instead, which iterates over the collection once and avoids intermediate allocations.
