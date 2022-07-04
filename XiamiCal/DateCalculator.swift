// Created by Tiga Liang on 2022/6/29.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct DateCalculator: View {
  @State private var input: String = ""
  @State private var typeChoice = "天"
  @State private var beforeOrAfterChoice = "后"
  @State var calculateResult: Date?

  let dateFormatter = DateFormatter()
  let calendar = Calendar.current

  let startDate: Date

  init(startDate: Date) {
    self.startDate = startDate
  }

  func startDateText() -> String {
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: startDate)
  }

  func calculateResultText() -> String {
    if let resultDate = calculateResult {
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.string(from: resultDate)
    }
    return "?"
  }

  var body: some View {
    VStack {
      Text("开始日期：\(startDateText())")

      HStack {
        TextField("", text: $input)
          .frame(width: 40)
          .multilineTextAlignment(.center)

        Picker("", selection: $typeChoice) {
          ForEach(["天", "周", "月", "年"], id: \.self) {
            Text($0)
          }
        }.frame(width: 50, alignment: .center)

        Picker("", selection: $beforeOrAfterChoice) {
          ForEach(["后", "前"], id: \.self) {
            Text($0)
          }
        }.frame(width: 50, alignment: .center)

        Button("计算") {
          if let quantity = Int(input) {
            var byAdding: Calendar.Component = .day
            var multipleDay = 1

            switch typeChoice {
            case "天":
              byAdding = .day
            case "周":
              byAdding = .day
              multipleDay = 7
            case "月":
              byAdding = .month
            case "年":
              byAdding = .year
            default:
              byAdding = .day
            }

            let beforeOrAfter = beforeOrAfterChoice == "后" ? 1 : -1

            calculateResult = calendar.date(byAdding: byAdding, value: quantity * multipleDay * beforeOrAfter, to: startDate)
          }
        }
      }

      Text("结果：\(calculateResultText())")
    }
  }
}

struct DateCalculator_Previews: PreviewProvider {
  static var previews: some View {
    DateCalculator(startDate: Date())
  }
}
