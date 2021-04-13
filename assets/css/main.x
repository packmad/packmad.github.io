---
# Only the main Sass file needs front matter (the dashes are enough)
---

@charset "utf-8";

@import "minimal-mistakes/skins/{{ site.minimal_mistakes_skin | default: 'default' }}"; // skin
@import "minimal-mistakes"; // main partials


/*
GS: override any CSS with new CSS styles AFTER the `@import "minimal-mistakes";` line just above!
See: https://github.com/mmistakes/minimal-mistakes/issues/1219#issuecomment-326809412
Anything you place after this point will therefore "cascade and override" the previous CSS styles.
*/

/*
GS: Decrease font sizes of the entire website.
Defaults for small, medium, large, and x-large screens are:
16, 18, 20, and 22px, in that order. All other font sizes are "em"
[typography unit](https://en.wikipedia.org/wiki/Em_(typography)) multipliers of these pixel
(px) values, and are therefore relative to and changed by these singular pixel values.
See: https://github.com/mmistakes/minimal-mistakes/issues/1219#issuecomment-326809412
- It looks like the screen pixel sizes to move into each new "size" category are defined in
  the "Breakpoints" section of "_variables.scss"?
*/
html {
  font-size: 20px; // change to whatever

  @include breakpoint($small) {
    font-size: 16px; // change to whatever
  }

  @include breakpoint($medium) {
    font-size: 18px; // change to whatever
  }

  @include breakpoint($large) {
    font-size: 20px; // change to whatever
  }

  @include breakpoint($x-large) {
    font-size: 22px; // change to whatever
  }
}
