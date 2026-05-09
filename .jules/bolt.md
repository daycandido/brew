## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.
## 2024-05-24 - Array vs Set in recursive traversals
**Learning:** Using an `Array` instead of a `Set` for membership checks (`include?`) in recursive dependency traversals like `cleanup.rb` causes time complexity to be O(N).
**Action:** Always use a `Set` instead of an `Array` for tracking visited nodes or elements in recursive traversals to reduce time complexity to O(1).
## 2024-05-24 - Avoid select.map
**Learning:** Chaining `.select { ... }.map { ... }` or `.select { ... }.flat_map { ... }` evaluates the entire collection and allocates multiple intermediate arrays, increasing garbage collection pressure.
**Action:** Prefer `.filter_map { ... }` over chaining to avoid intermediate array allocations and reduce memory overhead.
