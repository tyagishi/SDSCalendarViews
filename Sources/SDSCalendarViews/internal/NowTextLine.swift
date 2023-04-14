//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

struct NowTextLine: View {
    @Environment(\.calendarViewFontDic) var fontDic
    @Environment(\.calendarViewWidthDic) var widthDic
    let now: Date

    var body: some View {
        HStack(spacing: 0) {
            Text(CalendarViewModel.formattedTime(now))
                .font(fontDic[.nowLine])
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(.red)
                .padding(.horizontal, 3)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(width: widthDic[.timeColumn])
            VStack(spacing: 0) {
                Divider().background(.red)
            }
        }
    }
}

struct NowTextLine_Previews: PreviewProvider {
    static var previews: some View {
        NowTextLine(now: Date())
    }
}
