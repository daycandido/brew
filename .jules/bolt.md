## 2024-05-24 - Prefer .any? over .map.include?
**Learning:** Using `.map(&:property).include?(value)` is inefficient because it iterates the entire collection, allocates a new array for mapped values, and then searches the array. In contrast, `.any? { |item| item.property == value }` short-circuits on the first match and avoids intermediate array allocations, resulting in significant execution time and memory improvements.
**Action:** Always prefer `.any?` over `.map.include?` for inclusion checks on object properties.
