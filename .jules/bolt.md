## 2026-10-28 - Array Mapping Performance
**Learning:** In Ruby, chaining `.map(&:property).any?` allocates an intermediate array and iterates over the entire collection, which can be inefficient.
**Action:** Use `.any?(&:property)` directly on the collection to short-circuit the evaluation and avoid unnecessary array allocations.
