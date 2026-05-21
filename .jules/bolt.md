## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-24 - Avoid select.map.include?
**Learning:** Using `.select(&:property).map(&:value).include?(target)` iterates multiple times and allocates multiple intermediate arrays, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property && item.value == target }` instead, which short-circuits upon finding a match and avoids all intermediate allocations.

## 2024-05-24 - Safely access deeply nested Hash keys
**Learning:** Using chained brackets like `hash['key1']['key2']['key3']` on nested JSON data will raise a `NoMethodError: undefined method '[]' for nil` if any intermediate key is missing or nil.
**Action:** Prefer `Hash#dig('key1', 'key2', 'key3')` over chained brackets to safely access deeply nested keys, returning nil instead of throwing exceptions.
