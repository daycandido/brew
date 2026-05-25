## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-05-25 - Avoid select followed by map
**Learning:** Using `.select { ... }.map { ... }` or `.select(&:m1).map(&:m2)` allocates an intermediate array for the result of `select`, increasing garbage collection pressure and reducing performance.
**Action:** Use `.filter_map { |x| x.m2 if x.m1 }` instead to avoid intermediate array allocations and reduce garbage collection pressure.
