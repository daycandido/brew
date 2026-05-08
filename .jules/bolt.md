## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-24 - Avoid map.select.map
**Learning:** Chaining array methods like `map.select.map` allocates intermediate arrays, increasing garbage collection pressure and reducing speed.
**Action:** Use `.filter_map` to condense the loop and evaluate elements in a single pass without intermediate array allocations.
