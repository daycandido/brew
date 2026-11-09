
## 2024-05-30 - Optimize Array Lookup
**Learning:** Checking existence in an array of objects using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` to allow short-circuit evaluation and prevent intermediate array allocation, thereby improving performance when evaluating collections.
