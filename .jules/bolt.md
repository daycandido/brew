## 2024-05-14 - Optimize array includes after map
**Learning:** Checking for inclusion in mapped collections (e.g. `array.map { ... }.include?(value)`) iterates over the whole collection to create a new array and then iterates again to find the element. Using `any?` (e.g. `array.any? { ... == value }`) stops on the first match and prevents intermediate array creation.
**Action:** Always prefer `any?` over `map.include?` when checking if transformed elements contain a specific value.
