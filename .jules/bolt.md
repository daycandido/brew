## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2026-06-04 - Avoid select.map
**Learning:** Using `.select(&:property).map(&:other_property)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.filter_map { |item| item.other_property if item.property }` instead to avoid intermediate allocations and speed up processing.
## 2025-02-12 - Avoid any? with include? for array intersection
**Learning:** Using `array1.any? { |item| array2.include?(item) }` evaluates the collection using a Ruby loop and is generally O(N * M) time complexity.
**Action:** Use `array1.intersect?(array2)` instead, which short-circuits, is implemented in C, avoids block overhead, and provides an efficient check for intersection.
