## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-24 - Avoid select.map
**Learning:** Using `.select { ... }.map { ... }` evaluates the entire collection and allocates an intermediate array before mapping, increasing garbage collection pressure.
**Action:** Use `.filter_map { ... }` instead, which filters and maps in a single pass, avoiding temporary allocations and improving execution speed.
