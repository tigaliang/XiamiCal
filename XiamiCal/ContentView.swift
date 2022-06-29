// Created by Tiga Liang on 2022/6/27.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct ContentView: View {
  private let zodiac = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
  private let zodiacEmoji = ["🐭", "🐮", "🐯", "🐰", "🐲", "🐍", "🐎", "🐐", "🐒", "🐔", "🐶", "🐷"]
  private let tiangan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
  private let dizhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]

  private let titleFormatter = DateFormatter()
  private let calendar = Calendar.current

  @State private var calculatorShowing = false
  @State private var displayDate = Date()

  init() {
    titleFormatter.dateFormat = "YYYY 年 MM 月"
  }

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

  var body: some View {
    let today = Date()

    let displayComps = calendar.dateComponents([.year, .month], from: displayDate)
    let currentComps = calendar.dateComponents([.year, .month], from: today)

    VStack {
      ZStack(alignment: Alignment.center) {
        let displayYear = displayComps.year ?? 2022
        let displayZodiacIdx = displayZodiacIndex(displayYear)
        Text(zodiacEmoji[displayZodiacIdx]).font(.system(size: 200)).opacity(0.1)

        VStack {
          Text("\(tiangan[displayTianganIndex(displayYear)])\(dizhi[displayZodiacIdx])\(zodiac[displayZodiacIdx])年")
            .font(.system(size: 10))
            .opacity(0.5)

          ZStack {
            HStack {
              Button(action: {
                displayDate = today
              }) {
                Image(systemName: "gobackward")
              }.padding(Edge.Set.trailing, 15)
                .help("回到今天")
                .buttonStyle(PlainButtonStyle())
            }.frame(maxWidth: .infinity, alignment: Alignment.trailing)
              .opacity(displayComps.year != currentComps.year
                       || displayComps.month != currentComps.month ? 0.6 : 0)

            HStack {
              Button(action: {
                displayDate = calendar.date(byAdding: .year, value: -1, to: displayDate) ?? displayDate
              }) {
                Image(systemName: "chevron.left.2")
              }.buttonStyle(PlainButtonStyle())
                .padding(Edge.Set.trailing, 10)

              Button(action: {
                displayDate = calendar.date(byAdding: .month, value: -1, to: displayDate) ?? displayDate
              }) {
                Image(systemName: "chevron.left")
              }.buttonStyle(PlainButtonStyle())

              Text(titleFormatter.string(from: displayDate))
                .font(Font.title3)
                .bold()

              Button(action: {
                displayDate = calendar.date(byAdding: .month, value: 1, to: displayDate) ?? displayDate
              }) {
                Image(systemName: "chevron.right")
              }.buttonStyle(PlainButtonStyle())

              Button(action: {
                displayDate = calendar.date(byAdding: .year, value: 1, to: displayDate) ?? displayDate
              }) {
                Image(systemName: "chevron.right.2")
              }.buttonStyle(PlainButtonStyle())
                .padding(Edge.Set.leading, 10)
            }
          }.padding(Edge.Set.bottom, 10)

          let data = (1...30).map { "\($0)" }
          let gridItem = GridItem(.flexible(minimum: 40), alignment: Alignment.center)
          LazyVGrid(
            columns: [gridItem, gridItem, gridItem, gridItem, gridItem, gridItem, gridItem],
            spacing: 10
          ) {
            ForEach(data, id: \.self) { item in
              VStack {
                ZStack {
                  if item == "5" {
                    Circle()
                      .frame(width: 25, height: 25, alignment: Alignment.center)
                      .foregroundColor(Color.accentColor)
                  } else if item == "10" {
                    Circle()
                      .strokeBorder(Color.accentColor)
                      .frame(width: 25, height: 25, alignment: Alignment.center)
                      .foregroundColor(Color.accentColor)
                  } else {
                    Circle()
                      .frame(width: 25, height: 25, alignment: Alignment.center)
                      .foregroundColor(Color.clear)
                  }
                  Text(item).font(Font.body)
                }

                if item == "10" {
                  Text("廿三(休)").font(.system(size: 8)).opacity(0.5).padding(Edge.Set.top, -5)
                } else if item == "20" {
                  Text("廿三(班)").font(.system(size: 8)).opacity(0.5).padding(Edge.Set.top, -5)
                } else {
                  Text("廿三").font(.system(size: 8)).opacity(0.5).padding(Edge.Set.top, -5)
                }
              }
            }
          }
        }
      }

      Divider()

      HStack{
        Label("日期计算", systemImage: "calendar.badge.plus")
          .labelStyle(.titleAndIcon)

        if calculatorShowing {
          Image(systemName: "chevron.up")
        } else {
          Image(systemName: "chevron.down")
        }
      }.padding(Edge.Set.bottom, 10)
        .onTapGesture {
          calculatorShowing.toggle()
        }

      if calculatorShowing {
        DateCalculator()
      }
    }.padding(Edge.Set.top, calculatorShowing ? 35 : 18.7)
      .padding(Edge.Set.bottom, calculatorShowing ? 35 : 10)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
