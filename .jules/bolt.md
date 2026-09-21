## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2026-06-04 - Avoid select.map
**Learning:** Using `.select(&:property).map(&:other_property)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.filter_map { |item| item.other_property if item.property }` instead to avoid intermediate allocations and speed up processing.
## 2024-05-23 - Avoid .any? { |item| collection.include?(item) } in favor of .intersect?

**Learning:** Using `.any? { |item| collection.include?(item) }` (or similar constructions) evaluates multiple includes. `Array#intersect?` is more efficient and direct for checking array intersection in Ruby, as noted by `Style/ArrayIntersect` RuboCop offenses. Note `Array#intersect?` requires arrays.

**Action:** When finding `.any? { |item| array.include?(item) }` pattern, replace with `array1.intersect?(array2)` (ensuring arrays are passed or converted via `to_a`) for better efficiency and readability.
