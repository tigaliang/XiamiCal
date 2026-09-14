#!/bin/zsh
set -eu
cd "$(dirname "$0")/.."
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/xiami-checks.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT
xcrun swiftc -target "$(uname -m)-apple-macos12.3" -module-cache-path "$build_dir/modules" \
  XiamiCal/CalendarData.swift XiamiCal/HolidayUtils.swift XiamiCal/Utils.swift \
  XiamiCal/GlassStyle.swift XiamiCal/CalendarView.swift XiamiCal/CalendarHeader.swift \
  XiamiCal/ContentView.swift Tests/CalendarChecks.swift -o "$build_dir/calendar-checks"
"$build_dir/calendar-checks"
