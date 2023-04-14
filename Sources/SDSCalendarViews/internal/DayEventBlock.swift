//
//  DayEventBlock.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

public struct DayEventBlock: View {
    @Environment(\.calendarViewFontDic) var fontDic
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic
    @Environment(\.calendarViewAlignmentDic) var alignmentDic

    @ObservedObject var viewModel: CalendarViewModel
    let date: Date

    public init( _ viewModel: CalendarViewModel, date: Date) {
        self.viewModel = viewModel
        self.date = date
    }
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.allDayEventFor(date)) { allDayEvent in
                Text(" " + allDayEvent.title)
                    .lineLimit(1).minimumScaleFactor(0.1)
                    .font(fontDic[.dayEvent])
                    .foregroundColor(allDayEvent.color)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignmentDic[.dayEvent])
        .frame(width: widthDic[.day(date.formatted(.cvKeyStyle))], height: heightDic[.dayEvent])
    }
}

struct DayEventBlock_Previews: PreviewProvider {
    static var previews: some View {
        DayEventBlock(CalendarViewModel.exampleForWeekView(), date: Date())
    }
}
