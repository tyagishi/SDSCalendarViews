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
        let tcKey = CalendarDicKey.timeColumn.rawValue
        let hgtKey = CalendarDicKey.hourBlock.rawValue
        VStack(spacing: 0) {
            ForEach(viewModel.hourRanges(date), id: \.self) { hour in
                Text(CalendarViewModel.formattedTime(hour.lowerBound)).minimumScaleFactor(0.1)
                    .monospacedDigit()
                    .font(fontDic[tcKey])
                    .padding(.leading, 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignmentDic[tcKey])
                    .frame(width: widthDic[tcKey], height: heightDic[hgtKey])
            }
        }
    }
}

struct TimeColumn_Previews: PreviewProvider {
    static var previews: some View {
        TimeColumn(viewModel: CalendarViewModel.exampleForWeekView(), date: Date())
    }
}
