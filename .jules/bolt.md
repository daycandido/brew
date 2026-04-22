## 2024-05-24 - Avoid `.map.include?` in favor of `.any?`
**Learning:** Using `.map(&:property).include?(value)` is inefficient because it iterates over the entire collection to create an intermediate array before checking for inclusion. `any?` short-circuits upon finding the first match and avoids array allocation.
**Action:** Always prefer `.any? { |item| item.property == value }` for presence checks in collections to improve execution time and memory usage.
