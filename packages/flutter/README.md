# searchadsradar

Official [SearchAdsRadar](https://searchadsradar.com) SDK for Flutter —
first-party Apple Search Ads attribution from the device. No IDFA, no ATT
prompt.

## Requirements

- **iOS 16.0+** (set `platform :ios, '16.0'` in `ios/Podfile` if your app
  targets lower — the SDK will not build below 16).
- Flutter 3.22+.
- Android / web: every call is a safe no-op — Apple Search Ads is iOS-only.

## Install

```sh
flutter pub add searchadsradar
```

## Quick start

```dart
import 'package:searchadsradar/searchadsradar.dart';

// At app launch. Get your key from Connections → SearchAdsRadar SDK.
await SearchAdsRadar.configure(apiKey: 'sar_live_...');

// When the user signs in:
await SearchAdsRadar.identify('your-user-id');

// Custom events (values: String/num/bool/null):
await SearchAdsRadar.track('onboarding_done', {'plan': 'pro'});

// On logout:
await SearchAdsRadar.reset();
```

Verify: your app's Connections page in SearchAdsRadar flips to **Connected**
within about a minute of the first launch. If it doesn't, re-check the API
key — an invalid key fails silently by design (the SDK never crashes or
blocks your app).

## What gets captured

- **Attribution** — the Apple AdServices token, resolved server-side to
  campaign / ad group / keyword.
- **Purchases** — via a StoreKit 2 observer. Renewals, refunds and
  restores are captured as they happen; a purchase made inside the app
  surfaces at the **next app launch**. Consumable products are not captured.
  Works alongside `in_app_purchase` and RevenueCat — the SDK observes and
  never finishes transactions.
- **Sessions & custom events.**

## Notes

- This package **contains** the SARKit native SDK — do not add SARKit to
  your iOS project separately (you would get two SDK instances double-sending).
- Keys are **per app**. Two apps (for example one native, one Flutter) each
  need their own key.
- Events queue offline (max 200, 7-day TTL) and retry on foreground.
