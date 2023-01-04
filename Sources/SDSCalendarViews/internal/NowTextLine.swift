//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

struct NowTextLine: View {
    let now: Date
    let labelWidth: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            Text(CalendarViewModel.formattedTime(now))
                .font(.caption)
                .minimumScaleFactor(0.1)
                .foregroundColor(.red)
                .padding(.horizontal, 3)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(width: labelWidth)
            VStack(spacing: 0) {
                Divider().background(.red)
            }
        }
    }
}

struct NowTextLine_Previews: PreviewProvider {
    static var previews: some View {
        NowTextLine(now: Date(), labelWidth: 280)
    }
}
