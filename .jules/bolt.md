## 2024-05-14 - Optimize array matching with any? instead of select.map.include?
**Learning:** Found `.select(&:sym_type?).map(&:value).include?(:build)` pattern which is inefficient as it allocates multiple intermediate arrays.
**Action:** Replaced with `.any? { |t| t.sym_type? && t.value == :build }` which short-circuits and prevents unnecessary array allocations, executing significantly faster (e.g., ~72% faster on benchmark).
