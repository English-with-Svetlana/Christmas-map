# Christmas Map — analysis and QA

Review date: 6 November 2026. Written in English. Provisional audience: beginner learners using A0-friendly prompts and A1 directions vocabulary; no formal CEFR level was supplied.

## Result and scope

Implemented the requested local HTML/CSS/JavaScript quest and `/docs` publication build. Original image files remain in place. There are no external fonts, audio files, frameworks, fetch calls or runtime services. No repository, commit, push or deployment was created.

**Automated logic checks and HTTP checks pass. Browser visual/interaction QA is incomplete:** the browser connector returned “No browser is available”; the native Safari attempt returned “Computer Use permissions are not granted”. No actual browser screenshots, iPad tests, live Genially tests or audible classroom-volume checks were performed. Simulated pointer and DOM tests below must not be read as real browser tests.

## Assets and visual inspection

- Original room: 1670 × 941 PNG, no alpha, 2,705,954 bytes.
- Original map: 1414 × 2000 PNG, no alpha, 179,051 bytes.
- Room derivative: same 1670 × 941 resolution, WebP quality 88, 422,438 bytes. Visually inspected. Exact original Mrs Claus artwork retained through image compression, without regeneration. Background uses proportional cover; the source differs from 16:9 by about 0.17%, so only a minimal vertical edge crop is needed to fill the stage without stretching.
- Map derivative: same 1414 × 2000 coordinates, transparent PNG, 290,288 bytes. Near-white pixels become transparent; remaining foreground pixels stay in their source positions. No tracing, repositioning or city-specific restyling was used.
- Visually inspected both the original map and the final derivative on parchment. All 14 labels and associated red dots remain: Aberdeen, Dundee, Glasgow, Edinburgh, Belfast, Leeds, Manchester, Birmingham, Norwich, Oxford, London, Bristol, Brighton, Plymouth. Original “LONDON” capitalisation is preserved. No claim of independently verified geographic accuracy is made.
- Detected exactly 14 connected red components, with comparable areas (983–1005 pixels); Manchester has 984 pixels. The derivative does not enlarge or highlight Manchester.
- Before registration the map is parked at x=1400, y=170, separate from the grid x=700…1350. The scroll text uses x=226…559; the grid does not intersect Mrs Claus or her scroll. These are source-layout checks, not verified browser bounds.
- Small map labels are intrinsically tiny at 640-pixel iframe width. The enlarged map dialog supplies a 707 × 1000 map with the completed route and intentional internal scrolling. Its real-device usability remains to be reviewed.

## Route analysis

Grid: 10 columns × 11 rows; 65 logical pixels per unit, origin (700,150). Initial point (1,9), facing north, with a red START marker and a neutral current-heading arrow. No future route segments are rendered.

| Instruction | Command | Result (x,y), heading |
|---|---|---|
| 1 | Go straight on 2 squares. | (1,7), north |
| 2 | Turn right. | (1,7), east |
| 3 | Go straight on. | (2,7), east |
| 4 | Turn left. | (2,7), north |
| 5 | Go straight on. | (2,6), north |
| 6 | Turn right. | (2,6), east |
| 7 | Go straight on. | (3,6), east |
| 8 | Turn left. | (3,6), north |
| 9 | Go straight on. | (3,5), north |
| 10 | Turn right. | (3,5), east |
| 11 | Go straight on. | (4,5), east |
| 12 | Turn right. | (4,5), south |
| 13 | Go straight on. | (4,6), south |
| 14 | Turn left. | (4,6), east |
| 15 | Go straight on. | (5,6), east |
| 16 | Turn left. | (5,6), north |
| 17 | Go straight on. | (5,5), north |

There are 18 accepted button actions: 10 unit forward moves and eight turns. The simulator is the shared source for movement, validation, path drawing and Undo. Tests check every action, boundaries and all 11 path points. No point repeats; the unit orthogonal path does not self-cross. Turns add no line segment. No other registered city dot intersects a route segment within 10 logical pixels.

## Registration method

Manchester’s measured original red-component centroid is **(899.7723577235772, 1068.8180894308944)**. The displayed map width is 495, height 700.1414427157, with scale **495 / 1414**. There is no image padding or border affecting that scale; its parked border is an external outline.

The final route endpoint is **(1025,475)**. Registration is calculated as:

```
mapLeft = 1025 - centroidX * 495 / 1414
mapTop  =  475 - centroidY * 495 / 1414
```

The endpoint and dot centre coincide to floating-point tolerance (< 1e-9 logical pixels in the tests). Drag positions are converted from viewport pixels back to 1920 × 1080 stage coordinates. Releasing within 180 logical pixels of registration snaps the map; the keyboard-accessible Place map on grid button uses exactly the same registration. The map then becomes transparent with 0.87 global opacity, while the grid remains beneath. The route cursor is hidden during the map/answer phase so the city dot receives no additional marker.

## Tests actually run

`node scripts/test.cjs` — PASS, after final game changes.

- Simulate all 17 instructions / 18 actions and check counts, boundaries, rotations and non-repeating route points.
- Attempt an incorrect action before each accepted action; committed state remains identical.
- First forward tap does not advance the two-square instruction; Undo restores its prior progress.
- Undo from the map phase returns to the final route action; accepting it restores map phase.
- Exercise pointer down/move/up handlers using synthetic viewport geometry at widths 1920, 1280, 640 and 375. Confirm registration and endpoint equality at every size. This checks coordinate conversion, not touch hardware or browser pointer capture.
- Open/close the enlarged map dialog using a DOM harness.
- Wrong city retains map phase and reports only “Try again!”; correct answer with mixed case and surrounding spaces reaches victory.
- Confirm 70 confetti elements are created; animation rendering is unverified.
- Mock Web Audio: accepted actions and incorrect answers create oscillators with sound enabled by default; the original gain envelope remains unchanged. Audio playback, autoplay policy and perceived volume are unverified.
- Continue’s default handler preserves the final “Well done!” plaque; its configured URL branch still navigates in the iframe; Restart clears history, registration and confetti.

`python3 scripts/build.py` — PASS. Final `/docs` size: **728,641 bytes**, including `.nojekyll`, HTML, JS, CSS and media. All referenced production HTML/CSS asset paths resolve to local files. The root source and production pages use relative URLs suitable for project subpaths.

HTTP GET checks — **200** for `/`, `/iframe-preview.html`, `/docs/`, `/docs/index.html` and every hashed production CSS/JS/image asset. Server bound to `127.0.0.1:8765` in a retained execution session; it may stop if the session/app is closed.

## English-language review

Direction phrases use the requested wording with full stops. “Go straight on 2 squares.” uses the permitted simple count. Initial facing is explicit. The map prompt and destination question are split across the scroll and helper line. Incorrect responses do not expose the answer. All 14 city names appear only as part of the reference map before success. Instructional text reveals Manchester only after the correct typed response. Final message is “Hooray! Go to Manchester!”

## Fixes made during QA

- Switched to a direct bitmap pixel workflow to avoid colour conversion and reliably detect original red components.
- Used measured centroid values rather than rounded coordinates.
- Replaced an image border with an external outline so map content coordinates match the registration formula.
- Guarded browser-only resizing code so the same route module can be tested under Node.
- Centred the stage explicitly so responsive scaling does not depend on CSS grid’s intrinsic-size layout.
- Hid the route cursor after route completion and layered the enlarged map over its route line.
- Added a non-drag registration option and an enlarged map for small displays.
- Optimised the room to WebP and rebuilt content hashes after the last changes.

## Remaining manual review

Open both frames in `iframe-preview.html` and play the entire game in a real browser. Verify artwork composition, scroll text wrapping, city-label clarity, actual no-scroll viewport layout, focus rings, Tab/Enter and arrow keys, close-dialog focus, pointer capture, touch dragging, orientation changes, comfortable sound volume. Then test the real hosted URL inside Genially on desktop and iPad. Review reduced-motion behaviour and the final animation. No claim of completed browser/Genially QA is made.


## Targeted UI refinement — 6 November 2026

Changes are limited to the requested controls, plaques and final text. The image asset hashes, route instructions, grid and map geometry, answer validation, drag/snap math, Undo, Restart and confetti are preserved.

- Direction buttons contain only thick SVG arrows (left, up, right) and invisible accessible labels. Widths were matched to the previous Trebuchet bold text-button dimensions at both existing responsive sizes; positions, beige styling and click bindings remain the same. No direction gets a correctness highlight.
- The three existing header texts now have compact beige plaques with dark text; all wording is preserved. Their authored total bottom edge is y=133, above the grid background at y=138.
- “YOUR MAP · SAVE FOR LATER” retains its wording on a matching beige plaque at y=112…158, above the parked map at y=170.
- “Well done!” appears only in the won state, in a beige plaque at x=1440…1840, y=460…about570. This is right of the grid and registered map, and above the right-side controls. Restart hides it. The old teacher sentence is removed. Continue keeps its configured-URL action; with no URL it leaves the finished plaque visible.
- The final scroll text is exactly “Hooray! Go to Manchester!”; other instructional strings remain unchanged.
- The sound button, toggle handler and muted state are removed. Audio still initializes only through existing user action handlers. Gain remains `.17/4` per note, with the same soft envelope and previous-effect stopping logic. No background music was added.

Checks rerun: JavaScript syntax check, all gameplay DOM-harness tests, SVG-only button/aria-label source assertions, absence of the removed sound toggle, exact final wording, plaque state/reset, enabled sound generation, unchanged gain and both default/configured Continue branches. All pass. Asset references resolve locally. Header/map/final-plaque authored geometry clears neighbouring elements at 1280- and 640-pixel frame widths; this is a geometry calculation, not a browser screenshot.

The main game, iframe preview, production preview and every hashed production asset returned HTTP 200. Final production size is **728,641 bytes (about 712 KiB)**. Content hashing, relative paths and the `/docs` publication strategy remain unchanged.

Browser QA was attempted again: surface discovery found Chrome running, but no connected browser; native Chrome access returned “Computer Use permissions are not granted”. Actual rendering in normal/small frames, perceived arrow thickness, plaque readability, sound playback and live Genially behaviour therefore remain unverified. No browser screenshots or listening tests are claimed. Existing local preview links are available for manual review. Nothing was committed, pushed or deployed.
