// Created by Tiga Liang on 2022/6/29.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct DateCalculator: View {
  @State private var input: String = ""
  @State private var typeChoice = "天"
  @State private var beforeOrAfterChoice = "后"

  var body: some View {
    VStack {
      Text("当前：2022 / 06 / 29")

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
          // TODO
        }
      }

      Text("结果：2022 / 06 / 29")
    }
  }
}

struct DateCalculator_Previews: PreviewProvider {
  static var previews: some View {
    DateCalculator()
  }
}
