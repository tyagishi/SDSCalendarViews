//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

struct TimeColumn: View {
    @Environment(\.calendarViewFontDic) var fontDic
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic
    @Environment(\.calendarViewAlignmentDic) var alignmentDic

    @ObservedObject var viewModel: CalendarViewModel
    let date: Date

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.hourRanges(date), id: \.self) { hour in
                Text(CalendarViewModel.formattedTime(hour.lowerBound)).minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .monospacedDigit()
                    .font(fontDic[.timeColumn])
                    .padding(.leading, 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignmentDic[.timeColumn])
                    .frame(width: widthDic[.timeColumn], height: heightDic[.hourBlock])
            }
        }
    }
}

struct TimeColumn_Previews: PreviewProvider {
    static var previews: some View {
        TimeColumn(viewModel: CalendarViewModel.exampleForWeekView(), date: Date())
    }
}
