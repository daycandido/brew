## 2024-05-14 - Replace .map.any? with .any? for performance
**Learning:** Found multiple instances where collections are mapped to an array and then checked with `.any?`. This evaluates the entire collection and allocates an intermediate array before checking.
**Action:** Replace `.map(&:property).any?` with `.any?(&:property)` to avoid evaluating the entire collection and allocating an intermediate array, thus reducing garbage collection pressure and allowing the evaluation to short-circuit.
