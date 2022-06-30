// Created by Tiga Liang on 2022/6/30.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

private let zodiac = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
private let zodiacEmoji = ["🐭", "🐮", "🐯", "🐰", "🐲", "🐍", "🐎", "🐐", "🐒", "🐔", "🐶", "🐷"]
private let tiangan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
private let dizhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]

private func displayZodiacIndex(_ displayYear: Int) -> Int {
  var displayYearOffset = displayYear - 2020 // 鼠
  while displayYearOffset < 0 {
    displayYearOffset += 12
  }
  return displayYearOffset % 12
}

private func displayTianganIndex(_ displayYear: Int) -> Int {
  var displayYearOffset = displayYear - 2024 // 甲
  while displayYearOffset < 0 {
    displayYearOffset += tiangan.count
  }
  return displayYearOffset % 10
}

struct ZodiacEmoji: View {
  let displayYear: Int!

  var body: some View {
    Text(zodiacEmoji[displayZodiacIndex(displayYear)]).font(.system(size: 200)).opacity(0.1)
  }
}

struct ZodiacEmoji_Previews: PreviewProvider {
  static var previews: some View {
    ZodiacEmoji(displayYear: 2022)
  }
}

struct TianganDizhi: View {
  let displayYear: Int!

  var body: some View {
    let displayZodiacIdx = displayZodiacIndex(displayYear)
    Text("\(tiangan[displayTianganIndex(displayYear)])\(dizhi[displayZodiacIdx])\(zodiac[displayZodiacIdx])年")
      .font(.system(size: 10))
      .foregroundColor(Color.gray)
  }
}

struct TianganDizhi_Previews: PreviewProvider {
  static var previews: some View {
    TianganDizhi(displayYear: 2022)
  }
}
