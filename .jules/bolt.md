## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-24 - Avoid select.map.include?
**Learning:** Using `.select(&:property).map(&:value).include?(target)` iterates multiple times and allocates multiple intermediate arrays, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property && item.value == target }` instead, which short-circuits upon finding a match and avoids all intermediate allocations.
