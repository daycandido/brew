## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-05-24 - Avoid select.map
**Learning:** Chaining `.select` or `.select(&:property)` with `.map` or `.map(&:property)` evaluates the collection multiple times or creates intermediate arrays, increasing GC pressure.
**Action:** Use `.filter_map { |item| item.mapped_property if item.condition }` instead for a single pass evaluation and fewer allocations.
