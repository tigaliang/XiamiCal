// Created by Tiga Liang on 2022/7/4.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import Foundation

// See http://www.shijian.cc/116/jieri_2022/
private let holidays2022 = [
  101: "元旦",
  122: "春节",
  205: "元宵节",
  221: "中和节",
  308: "妇女节",
  312: "植树节",
  405: "清明节",
  501: "劳动节",
  504: "青年节",
  601: "儿童节",
  603: "端午节",
  701: "建党节",
  711: "航海日",
  801: "建军节",
  804: "七夕节",
  812: "中元节",
  910: "教师节\n中秋节",
  1001: "国庆节",
  1004: "重阳节",
  1108: "记者节"
]

private let holidays2023 = [
  101: "元旦",
  201: "春节",
  215: "元宵节",
  304: "中和节",
  308: "妇女节",
  312: "植树节",
  405: "清明节",
  501: "劳动节",
  504: "青年节",
  601: "儿童节",
  622: "端午节",
  701: "建党节",
  711: "航海日",
  801: "建军节",
  822: "七夕节",
  830: "中元节",
  910: "教师节",
  929: "中秋节",
  1001: "国庆节",
  1023: "重阳节",
  1108: "记者节"
]

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
]

func getHolidayText(year: Int, month: Int, day: Int) -> String? {
  switch year {
  case 2022:
    return holidays2022[month * 100 + day]
  case 2023:
    return holidays2023[month * 100 + day]
  default:
    return nil
  }
}

func getDayOffText(year: Int, month: Int, day: Int) -> String? {
  switch year {
  case 2022:
    return dayOffs2022[month * 100 + day]
  default:
    return nil
  }
}
