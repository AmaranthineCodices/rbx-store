In rbx-store, the **state** in your game is the single source of truth. Typically, you will only have one root-level store for this state, which every part of your game interacts with. A singular state table means it is impossible for you to forget to synchronize state - if there is only one source of state, everything that uses it is automatically in sync with everything else.

This also allows easy debugging. You can use [plugins](./plugins.md) to respond to changes in the state in one centralized location, allowing really easy inspection of every piece of data in your game.

## Local state is still okay!
It's okay to have local state! In many cases, a lot of things *shouldn't* be stored in your game's state table, because they simply aren't relevant to anything else and they're really simple.
