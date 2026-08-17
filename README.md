# SearchAdsRadar Mobile SDKs

Cross-platform wrapper packages over the native
[SARKit iOS SDK](https://github.com/appnest-tech/searchadsradar-ios-sdk).

| Package | Registry | Status |
|---|---|---|
| `packages/flutter` | pub.dev `searchadsradar` | v1 |
| `packages/react_native` | npm `@searchadsradar/react-native` | planned |

## How vendoring works

`SARKIT_VERSION` pins one upstream SARKit tag. `tool/sync-sarkit.sh` clones that
tag, strips cross-module `import SARKitCore` lines (upstream is two Swift
modules; packages compile it as one), carries `PrivacyInfo.xcprivacy`, and fans
the result out into each package. CI re-runs the sync and fails on any diff —
never hand-edit `vendor/` or `.../vendored/`.

To upgrade SARKit: bump `SARKIT_VERSION`, run `./tool/sync-sarkit.sh`, commit,
release the packages.

Requires iOS 16.0+. Android is a safe no-op by design (Apple Search Ads is
iOS-only).
