// Created by Tiga Liang on 2022/7/4.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import Foundation

// See http://www.gov.cn/zhengce/content/2021-10/25/content_5644835.htm
private let dayOffs2022 = [
  101: "休",
  102: "休",
  103: "休",
  129: "班",
  130: "班",
  131: "休",
  201: "休",
  202: "休",
  203: "休",
  204: "休",
  205: "休",
  206: "休",
  402: "班",
  403: "休",
  404: "休",
  405: "休",
  430: "休",
  501: "休",
  502: "休",
  503: "休",
  504: "休",
  424: "班",
  507: "班",
  603: "休",
  604: "休",
  605: "休",
  910: "休",
  911: "休",
  912: "休",
  1001: "休",
  1002: "休",
  1003: "休",
  1004: "休",
  1005: "休",
  1006: "休",
  1007: "休",
  1008: "班",
  1009: "班",
  1231: "休",
]

// See http://www.gov.cn/zhengce/content/2022-12/08/content_5730844.htm
private let dayOffs2023 = [
  101: "休",
  102: "休",
  121: "休",
  122: "休",
  123: "休",
  124: "休",
  125: "休",
  126: "休",
  127: "休",
  128: "班",
  129: "班",
  405: "休",
  423: "班",
  429: "休",
  430: "休",
  501: "休",
  502: "休",
  503: "休",
  506: "班",
  622: "休",
  623: "休",
  624: "休",
  625: "班",
  929: "休",
  930: "休",
  1001: "休",
  1002: "休",
  1003: "休",
  1004: "休",
  1005: "休",
  1006: "休",
  1007: "班",
  1008: "班",
  1230: "休",
  1231: "休",
]

// https://www.gov.cn/zhengce/content/202310/content_6911527.htm
private let dayOffs2024 = [
  101: "休",
  204: "班",
  210: "休",
  211: "休",
  212: "休",
  213: "休",
  214: "休",
  215: "休",
  216: "休",
  217: "休",
  218: "班",
  404: "休",
  405: "休",
  406: "休",
  407: "班",
  428: "班",
  501: "休",
  502: "休",
  503: "休",
  504: "休",
  505: "休",
  511: "班",
  610: "休",
  914: "班",
  915: "休",
  916: "休",
  917: "休",
  929: "班",
  1001: "休",
  1002: "休",
  1003: "休",
  1004: "休",
  1005: "休",
  1006: "休",
  1007: "休",
  608: "休",
  609: "休",
  1012: "班"
]

// https://www.gov.cn/gongbao/2024/issue_11726/202411/content_6989767.html
private let dayOffs2025 = [
    101: "休",  // New Year's Day (Wednesday)
    126: "班",  // Work on Sunday
    128: "休",  // Spring Festival Eve
    129: "休",
    130: "休",
    131: "休",
    201: "休",
    202: "休",
    203: "休",
    204: "休",
    208: "班",  // Work on Saturday
    404: "休",  // Qingming Festival
    405: "休",
    406: "休",
    427: "班",  // Work on Sunday
    501: "休",  // Labor Day
    502: "休",
    503: "休",
    504: "休",
    505: "休",
    531: "休",  // Dragon Boat Festival
    601: "休",
    602: "休",
    928: "班",  // Work on Sunday
    1001: "休", // National Day & Mid-Autumn Festival combined
    1002: "休",
    1003: "休",
    1004: "休",
    1005: "休",
    1006: "休",
    1007: "休",
    1008: "休",
    1011: "班"  // Work on Saturday
]

// http://www.scio.gov.cn/zdgz/jj/202511/t20251110_938367.html
private let dayOffs2026 = [
  101: "休",
  102: "休",
  103: "休",
  104: "班",
  214: "班",
  215: "休",
  216: "休",
  217: "休",
  218: "休",
  219: "休",
  220: "休",
  221: "休",
  222: "休",
  223: "休",
  228: "班",
  404: "休",
  405: "休",
  406: "休",
  501: "休",
  502: "休",
  503: "休",
  504: "休",
  505: "休",
  509: "班",
  619: "休",
  620: "休",
  621: "休",
  920: "班",
  925: "休",
  926: "休",
  927: "休",
  1001: "休",
  1002: "休",
  1003: "休",
  1004: "休",
  1005: "休",
  1006: "休",
  1007: "休",
  1010: "班"
]

func getHolidayText(year: Int, month: Int, day: Int) -> String? {
  var calendar = Calendar(identifier: .gregorian)
  calendar.timeZone = TimeZone(secondsFromGMT: 0)!
  guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12)) else { return nil }
  let value = CalendarDay(date: date, calendar: calendar)
  guard value.year == year, value.month == month, value.day == day else { return nil }
  return value.holiday
}

func getDayOffText(year: Int, month: Int, day: Int) -> String? {
  switch year {
  case 2022:
    return dayOffs2022[month * 100 + day]
  case 2023:
    return dayOffs2023[month * 100 + day]
  case 2024:
    return dayOffs2024[month * 100 + day]
  case 2025:
    return dayOffs2025[month * 100 + day]
  case 2026:
    return dayOffs2026[month * 100 + day]
  default:
    return nil
  }
}
