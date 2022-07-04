// Created by Tiga Liang on 2022/7/4.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import Foundation

extension DateComponents {
  func isSameDay(_ otherDate: Date) -> Bool {
    let other = Calendar.current.dateComponents([.year, .month, .day], from: otherDate)
    return self.year == other.year && self.month == other.month && self.day == other.day
  }

  func isSameMonth(_ otherDate: Date) -> Bool {
    let other = Calendar.current.dateComponents([.year, .month], from: otherDate)
    return self.year == other.year && self.month == other.month
  }
}

func constellationForDate(month: Int, day: Int) -> String {
  let mmdd = month * 100 + day;
  var result = ""

  if ((mmdd >= 321 && mmdd <= 331) ||
      (mmdd >= 401 && mmdd <= 419)) {
    result = "白羊座"
  } else if ((mmdd >= 420 && mmdd <= 430) ||
             (mmdd >= 501 && mmdd <= 520)) {
    result = "金牛座"
  } else if ((mmdd >= 521 && mmdd <= 531) ||
             (mmdd >= 601 && mmdd <= 621)) {
    result = "双子座"
  } else if ((mmdd >= 622 && mmdd <= 630) ||
             (mmdd >= 701 && mmdd <= 722)) {
    result = "巨蟹座"
  } else if ((mmdd >= 723 && mmdd <= 731) ||
             (mmdd >= 801 && mmdd <= 822)) {
    result = "狮子座"
  } else if ((mmdd >= 823 && mmdd <= 831) ||
             (mmdd >= 901 && mmdd <= 922)) {
    result = "处女座"
  } else if ((mmdd >= 923 && mmdd <= 930) ||
             (mmdd >= 1001 && mmdd <= 1023)) {
    result = "天秤座"
  } else if ((mmdd >= 1024 && mmdd <= 1031) ||
             (mmdd >= 1101 && mmdd <= 1122)) {
    result = "天蝎座"
  } else if ((mmdd >= 1123 && mmdd <= 1130) ||
             (mmdd >= 1201 && mmdd <= 1221)) {
    result = "射手座"
  } else if ((mmdd >= 1222 && mmdd <= 1231) ||
             (mmdd >= 101 && mmdd <= 119)) {
    result = "摩羯座"
  } else if ((mmdd >= 120 && mmdd <= 131) ||
             (mmdd >= 201 && mmdd <= 218)) {
    result = "水瓶座"
  } else if ((mmdd >= 219 && mmdd <= 229) ||
             (mmdd >= 301 && mmdd <= 320)) {
    result = "双鱼座"
  }
  return result
}
