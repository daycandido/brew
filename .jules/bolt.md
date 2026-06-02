## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-25 - Avoid flat_map.include?
**Learning:** Using `deps.flat_map(&:tags).include?(:test)` evaluates all elements and allocates intermediate arrays, increasing garbage collection pressure.
**Action:** Use `.any? { |dep| dep.tags.include?(:test) }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-25 - Fix htmlproofer issue
**Learning:** Add the URL to `ignore_urls` array inside `docs/Rakefile` for URLs where the anchor hash is not available.
**Action:** Append the URL string inside `ignore_urls` in `docs/Rakefile`.
