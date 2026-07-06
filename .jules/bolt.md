## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2026-06-04 - Avoid select.map
**Learning:** Using `.select(&:property).map(&:other_property)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.filter_map { |item| item.other_property if item.property }` instead to avoid intermediate allocations and speed up processing.
## 2026-07-06 - Avoid map.first and map.last
**Learning:** Using `.map(&:property).first` or `.map(&:property).last` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.first.property` or `.last.property` instead to avoid intermediate allocations.
