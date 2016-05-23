# Keyboard Extra

Higher level handling for keyboard inputs in Elm 0.17.

This library is a standard component following The Elm Architecture.

It is quite tedious to find out the currently pressed down keys with just the `Keyboard` module, so this package aims to make it easier. You can also get some bonus benefits out of this:

- Keys are named values of the `Key` type, including e.g. `ArrowUp`, `CharA` and `Enter`
- You can find out whether e.g. `CharC` is pressed down when any `Msg` happens in your program
- Arrow keys and WASD can be decoded into records similarly to Elm 0.16: `{ x : Int, y : Int }`
- You can also get a full list of keys that are pressed down, if you need to
