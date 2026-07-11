# Engineering principles

Follow these principles in order of importance:

1. Use domain language and consistent naming.
2. Keep modules cohesive and dependencies narrow.
3. Prefer the simplest existing solution.
4. Build only what current requirements justify.
5. Abstract only after a stable pattern emerges.
6. Follow established conventions unless deviation has a clear benefit.
7. Design contracts and module boundaries before implementation.
8. Make small, reviewable changes.

# Development workflow

For non-trivial changes:

1. Propose rough types, function signatures, and module boundaries.
2. Refine contracts and responsibilities with feedback.
3. Add minimal TODOs in the intended code locations.
4. Implement only when directly instructed.

Scale this process to the risk and complexity of the change. Trivial changes do not require staged feedback.

Refactor first when a change would reinforce poor code structure.
