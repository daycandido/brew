## 2024-05-24 - Optimize requirement evaluation in formula_auditor
**Learning:** In Ruby, using `.map(&:property).any?` forces evaluation of the entire array to create an intermediate array before checking for any truthy values. Using `.any?(&:property)` avoids the intermediate array and short-circuits evaluation.
**Action:** Whenever checking for boolean properties within collections in Ruby, prefer `.any?(&:property)` over chaining `.map` then `.any?` to reduce garbage collection pressure.
