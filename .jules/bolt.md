## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-05-15 - Short-circuiting Array Operations
**Learning:** Using `.select(&:property).map(&:value).include?(x)` evaluates the entire collection and allocates two intermediate arrays before checking inclusion.
**Action:** Use `.any? { |item| item.property && item.value == x }` to short-circuit upon finding a match and avoid intermediate array allocations, reducing time complexity and memory overhead.
