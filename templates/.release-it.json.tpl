{
  "git": {
    "commitMessage": "chore: release v${version}",
    "pushArgs": "--follow-tags -o ci.skip",
    "changelog": "npx auto-changelog --stdout --commit-limit false --unreleased --template https://raw.githubusercontent.com/release-it/release-it/main/templates/changelog-compact.hbs"
  },
  "gitlab": {
    "release": true
  },
  "plugins": {
    "@release-it/bumper": {
      "out": "./app/package.json"
    }
  },
  "npm": false,
  "hooks": {
    "before:init": "git fetch --prune --prune-tags origin",
    "after:bump": "npx auto-changelog -p app/package.json --output CHANGELOG.md --template keepachangelog"
  }
}