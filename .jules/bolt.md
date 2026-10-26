## 2026-10-26 - Optimize Array intersections
**Learning:** Ruby's `intersect?` is significantly faster than using `.any? { |item| array.include?(item) }` for checking array intersections, because it's implemented in C and avoids evaluating elements in Ruby blocks, thus providing a nice speed boost and better memory usage.
**Action:** Always use `.intersect?` when checking if two arrays share elements, rather than chaining iterators.
