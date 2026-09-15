# XiamiCal 1.7 submission

- Version: 1.7; build: 10.
- App Store Connect app: `1633055190`.
- Bundle ID: `win.tigaliang.XiamiCal`.
- Simplified Chinese metadata: `metadata-zh-Hans.json` (field lengths validated).
- Current 1.6 screenshots still depict the core calendar functionality; inherited screenshots can be retained for this update.

Validation on 2026-09-15:

- `Tests/run-checks.sh`: **422,462 checks passed**, including the historical festival regressions, coincident festivals, leap lunar months and uncovered schedule years.
- Release build succeeded for the macOS 12.3 deployment target.
- Signed universal archive (Intel and Apple silicon) succeeded and passed signature verification.
- Archive: `/private/tmp/xiami-appstore-1.7/XiamiCal.xcarchive`.
- Archive log: `/private/tmp/xiami-appstore-1.7/signed-archive.log`.
- Xcode export/upload succeeded at 12:22 China Standard Time. Upload log: `/private/tmp/xiami-appstore-1.7/upload.log`.
- Confirmed the compiled app declares Simplified Chinese and includes actual localized string resources.
- Development build UI checked: September 20 makeup workday, Settings layout, Command-Comma, and menu bar date setting.
- Real logout/login and macOS 12 runtime testing remain separate manual checks; the developer's login-start preference was not enabled during testing.

Storefront metadata and review submission status will be recorded below after saving and verifying in App Store Connect.
