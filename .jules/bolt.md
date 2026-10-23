## 2024-05-18 - Avoid array allocation in cleanup

**Learning:** In Ruby, calling `.select { |x| condition }.map(&:property)` or `.select { |x| condition }.flat_map(&:property)` iterates over the collection twice and allocates an intermediate array for the selected items before mapping.
**Action:** Use `.filter_map { |x| x.property if condition }` instead to iterate once, avoid the intermediate array allocation, and improve performance.
