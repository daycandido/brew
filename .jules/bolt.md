## 2025-01-20 - Refactor Array Intersections
**Learning:** Found multiple instances of inefficient `.any? { |val| other_array.include?(val) }` which allocates intermediate blocks and performs unoptimized array lookups.
**Action:** Use `array.intersect?(other_array)` which provides a native C implementation for checking intersections in Ruby, reducing execution time and garbage collection pressure.
