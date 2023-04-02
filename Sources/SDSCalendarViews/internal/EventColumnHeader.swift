//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/02
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

public struct EventColumnHeader<T: View>: View {
    @Environment(\.calendarViewFontDic) var fontDic
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic
    @Environment(\.calendarViewAlignmentDic) var alignmentDic

    let date: Date
    let label: T

    public init(date: Date, label: () -> T) {
        self.date = date
        self.label = label()
    }
    public var body: some View {
        label.font(fontDic[CalendarViewModel.formattedDate(date)])
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignmentDic["DayLabel"])
            .frame(width: widthDic[CalendarViewModel.formattedDate(date)], height: heightDic["DayLabel"])
    }
}
