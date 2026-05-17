## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-05-25 - Prefer filter_map over select.map
**Learning:** Chaining `.select { ... }.map { ... }` evaluates the collection twice and allocates an intermediate array, increasing memory overhead and garbage collection pressure.
**Action:** Use `.filter_map { ... }` instead, which performs the selection and mapping in a single pass without intermediate allocations.
