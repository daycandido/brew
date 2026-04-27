## 2024-05-18 - Avoid array allocation in condition check
**Learning:** Chaining `.select { ... }.map { ... }.include?(...)` allocates multiple intermediate arrays for the sole purpose of checking if a matching element exists.
**Action:** Use `.any? { |element| condition_1 && condition_2 }` instead to short-circuit the evaluation as soon as a match is found and completely avoid allocating intermediate arrays.
