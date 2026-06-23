## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2026-06-04 - Avoid select.map
**Learning:** Using `.select(&:property).map(&:other_property)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.filter_map { |item| item.other_property if item.property }` instead to avoid intermediate allocations and speed up processing.
## 2024-06-23 - Avoid flat_map.include?
**Learning:** Using `deps.flat_map(&:tags).include?(:test)` allocates an intermediate array for the entire collection before checking for inclusion, increasing garbage collection pressure.
**Action:** Use `deps.any? { |dep| dep.tags.include?(:test) }` instead, which short-circuits upon finding a match and avoids intermediate array allocations.
