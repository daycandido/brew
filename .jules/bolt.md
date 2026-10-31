## 2025-02-14 - Optimize `.map(&:any?)` logic
**Learning:** In Ruby, using `.map(&:property).any?` evaluates the entire collection and allocates an intermediate boolean array before checking for any truthy values.
**Action:** Use `.any?(&:property)` to avoid the intermediate allocation, which reduces garbage collection pressure and allows short-circuiting.
