# Calendar verification

Run `Tests/run-checks.sh` from the repository with Xcode 26 or newer selected.
The checks compile the calendar UI and model for the macOS 12.3 deployment target,
then verify Gregorian grids over a complete 400-year cycle in Shanghai and Los
Angeles, including daylight-saving changes. They also cover lunar leap months,
Chinese New Year, holiday/workday overrides, month boundaries, selection, Today,
and midnight refresh.

Build the app with:

```sh
xcodebuild -project XiamiCal.xcodeproj -scheme XiamiCal -configuration Release \
  -destination 'platform=macOS' -derivedDataPath /tmp/xiami-build \
  CODE_SIGNING_ALLOWED=NO build
```

For UI verification, launch a development build and check:

- The six-week popover stays the same size across months.
- Selecting an adjacent-month date opens that month and updates the detail card.
- Arrow keys move one day or one week after selecting a date.
- Command-Left/Right changes month; Option-Command-Left/Right changes year.
- Command-T restores today's month and selection; Escape closes the popover.
- The More menu provides Today and Quit.
- Day buttons expose the full date, lunar date, holiday, and selected state.
- Light and dark appearances keep labels and selection readable.
- Reduce Transparency uses solid surfaces; Reduce Motion removes custom motion.
- Command-Comma and the More menu open Settings. The menu bar date switch updates immediately and persists after quitting/reopening.
- On macOS 13+, Launch at Login reflects the system's enabled/requires-approval/disabled state. Verify enable, permission-required, disable and registration failure from a signed app in Applications; do not leave a test build registered.
- A real login-item launch stays silent. A user launch/reopen displays the calendar. Test a real logout/login separately; unit checks do not simulate it.
- On macOS 12.3, Settings provides the System Preferences login-item instructions instead of using unavailable ServiceManagement APIs.
- After changing year, the data information row reflects that displayed year. Unknown years explicitly disclose missing rest/work schedules, including VoiceOver.
- Verify the archived bundle has `CFBundleDevelopmentRegion = zh-Hans`, `CFBundleLocalizations = [zh-Hans]`, and `zh-Hans.lproj/Localizable.strings`.

Native Liquid Glass requires macOS 26. Earlier supported versions use regular
material. The deployment target is checked by compilation; older macOS runtime
behavior requires testing on a machine running that version.
