## 2024-04-21 - Optimize Ruby Select + Map with filter_map
**Learning:** Chaining `.select` and `.map` (or `.flat_map`) evaluates the collection twice and creates intermediate arrays.
**Action:** Use `.filter_map` instead of chaining `.select` and `.map` to reduce object allocations and improve performance, as it filters and maps in a single pass.
