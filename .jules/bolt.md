## 2024-05-18 - Optimize `.map.any?` arrays in Homebrew requirements check

**Learning:** Using `.map(&:recommended?).any?` creates an intermediate array containing all boolean values before iterating over it to evaluate `any?`. Since the block evaluates `any?` over the same array, it can be combined as `.any?(&:recommended?)`, avoiding the intermediate allocation entirely.

**Action:** When finding chains like `.map(&:method).any?` or similar block iterations over the collection, replace them with a simpler chained method call directly on the array like `.any?(&:method)`. This prevents unnecessary object allocation during the mapping phase and allows for short-circuit evaluation.
