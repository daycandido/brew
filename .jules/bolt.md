## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2024-05-18 - Avoid select.map.include?
**Learning:** Using `.select(&:sym_type?).map(&:value).include?(:build)` evaluates the whole collection, creating two intermediate arrays and checking inclusion on the final result.
**Action:** Prefer using `.any? { |item| condition }` over `.select.map.include?` to short-circuit iteration and avoid allocating multiple intermediate arrays.
