
## 2024-05-18 - Avoid map.any? in Ruby
**Learning:** Chaining `.map` followed by `.any?` forces the evaluation of the entire array, creating a large intermediate array and causing unnecessary garbage collection pressure and CPU overhead.
**Action:** Always prefer `.any?(&:method_name)` or `.any? { |item| item.method_name }` instead. This allows the iteration to short-circuit upon finding the first match and entirely avoids the intermediate array allocation.
## 2024-05-18 - Avoid map.any? in Ruby
**Learning:** Chaining `.map` followed by `.any?` forces the evaluation of the entire array, creating a large intermediate array and causing unnecessary garbage collection pressure and CPU overhead.
**Action:** Always prefer `.any?(&:method_name)` or `.any? { |item| item.method_name }` instead. This allows the iteration to short-circuit upon finding the first match and entirely avoids the intermediate array allocation.
