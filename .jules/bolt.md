## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2026-06-04 - Avoid select.map
**Learning:** Using `.select(&:property).map(&:other_property)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.filter_map { |item| item.other_property if item.property }` instead to avoid intermediate allocations and speed up processing.
## 2024-05-24 - Array Intersect
**Learning:** Using `array1.any? { |item| array2.include?(item) }` evaluates items sequentially and does a linear search in the second array. Using `.intersect?` is more readable and potentially faster when checking for set intersection on arrays.
**Action:** Use `.intersect?` when checking if two arrays have any items in common.
