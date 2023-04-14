//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/02
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

public struct EventColumnHeader: View {
    @Environment(\.calendarViewFontDic) var fontDic
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic
    @Environment(\.calendarViewAlignmentDic) var alignmentDic
    @Environment(\.calendarViewFormatStyleDic) var formatStyleDic

    let date: Date
    let firstDayFlag: Bool
    let todayFlag: Bool

    public init(date: Date, range: Range<Date>? = nil, today: Date? = nil) {
        self.date = date
        if let range = range,
           Calendar.current.isDate(date, inSameDayAs: range.lowerBound) {
            firstDayFlag = true
        } else {
            firstDayFlag = false
        }
        if let today = today,
           Calendar.current.isDate(date, inSameDayAs: today) {
            todayFlag = true
        } else {
            todayFlag = false
        }
    }
    public var body: some View {
//        let text = date.formatted(formatStyleDic[.])
        let formatStyle = formatStyleDic[firstDayFlag ? .leadDayLabel : .restDaysLabel] ??  .dateTime.month(.twoDigits).day(.twoDigits)
        let text = date.formatted(formatStyle)
        Text(text).font(fontDic[.day(date.formatted(.cvKeyStyle))])
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignmentDic[.dayLabel])
            .frame(width: widthDic[.day(date.formatted(.cvKeyStyle))], height: heightDic[.dayLabel])
    }
}
