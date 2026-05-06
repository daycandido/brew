## 2024-05-01 - Avoid select.map.include?
**Learning:** Using `select(&:sym_type?).map(&:value).include?(:build)` allocates multiple intermediate arrays and evaluates the entire collection before checking for inclusion.
**Action:** Prefer `.any? { |node| node.sym_type? && node.value == :build }` which avoids allocations and short-circuits.
