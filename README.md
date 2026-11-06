# Christmas Map

A local, buildless English directions game for a 16:9 Genially iframe. Originals `living room.png` and `map.png` remain unchanged. Production files are in `docs/`. Nothing has been committed, pushed or deployed.

## Review locally

The preview server was started on port 8765 and its pages were checked over HTTP. While that process is alive:

- Game: http://127.0.0.1:8765/
- Iframe review (1280 × 720 and 640 × 360): http://127.0.0.1:8765/iframe-preview.html
- Production: http://127.0.0.1:8765/docs/

To restart: run `python3 -m http.server 8765 --bind 127.0.0.1` from this folder. The URLs are local to this computer.

## Build and check

No dependencies or package installation are needed for the game or build:

```sh
node scripts/test.cjs
python3 scripts/build.py
```

Edit `index.html`, `style.css`, `game.js`, or `config.js`, then rebuild. The build recreates only `docs/` and hashes CSS, JS, configuration and media by content. CSS hashes include the final hashed image references. `docs/index.html` retains its permanent path. No service worker is installed. WebP requires a current browser (including Safari 14+); PNG is used for the map. The unused JPEG derivative is outside the production build.

The production folder totals **728,641 bytes (about 712 KiB)** after the final build; see QA.md for the measured final value if this number changes. Assets and game logic work without external services. Sound is generated with Web Audio after an action; no audio downloads are used.

## Play

Start at the red START marker, facing up. Select Go straight, Turn left or Turn right. A turn only rotates; forward moves one square per tap. Arrow keys also work when focus is outside a button/input; Tab and Enter operate the buttons. The first direction needs two forward taps. Wrong controls leave the committed state intact. Undo reverses one accepted button action, including partially completed movement instructions. Restart replays the entire game. Sound effects remain enabled at the original quiet gain; there is no sound toggle.

After the route, drag the map onto the grid. Releasing within 180 logical pixels of its registered top-left corner snaps it exactly into position. “Place map on grid” offers the same operation without dragging. Then type the city name and select Check. “Zoom map” opens an enlarged map with the completed route and intentional internal scrolling for small embeds. Close returns to the game. The final state displays a beige “Well done!” plaque. Continue retains the finished state by default.

## Continue and Genially

Set `continueUrl` in `config.js` to a real destination only if wanted, then rebuild. The configured URL opens in the game’s own iframe. With the default empty value, the finished game keeps the “Well done!” plaque visible. Advance the Genially presentation separately. This game does not attempt to control Genially’s parent frame. Cross-origin access and iframe sandbox permissions can prevent direct parent navigation; no Genially-specific navigation API was assumed or tested.

Copy the responsive snippet in `EMBED.html.txt` and replace its placeholder with the actual URL shown by GitHub Pages. A Genially URL embed can use that same URL directly, sized to 16:9. Use the same permanent URL after updates. Content hashes avoid stale asset filenames, but an already-open iframe must reload to fetch an updated HTML entry page; Genially or browser caches may still require a presentation refresh.

## Publish manually with GitHub Pages

1. Choose or create your own repository. Add this project, preserving `docs/` at its root. Commit and push manually to your chosen branch (for example `main`).
2. Open the repository’s **Settings → Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**.
4. Select the branch containing this project and the **/docs** folder; choose **Save**.
5. Wait for GitHub’s Pages deployment to finish. Copy the actual published URL from Settings → Pages. Open it and play a full route before embedding.
6. Replace the placeholder in `EMBED.html.txt` with that URL. Embed it into Genially at 16:9.
7. For later edits, run the checks and build above, then manually commit and push the changed source and `docs/` files to the same branch. Keep the same Pages settings and iframe URL.

GitHub reference: https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site

Browser rendering, physical touch, audible volume and a live Genially embed still need manual review. See QA.md for the distinction between measured tests and unverified browser behavior.
