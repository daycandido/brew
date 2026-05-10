## 2024-05-24 - Avoid map.include?
**Learning:** Using `.map(&:property).include?(value)` evaluates the entire collection and allocates an intermediate array, increasing garbage collection pressure.
**Action:** Use `.any? { |item| item.property == value }` instead, which short-circuits upon finding a match and avoids intermediate allocations.

## 2026-05-10 - Faster Array Inclusion Checks with any?
**Learning:** In Ruby, chaining `.select { ... }.map { ... }.include?(...)` on an array evaluates the entire collection twice (creating intermediate arrays) before checking for inclusion. While C-optimized `.select` and `.map` are fast individually, the combined overhead and memory allocation is slower than a single block-based check.
**Action:** Replace `array.select(&:sym_type?).map(&:value).include?(:build)` with `array.any? { |item| item.sym_type? && item.value == :build }` to short-circuit on the first match and avoid intermediate array allocations.
