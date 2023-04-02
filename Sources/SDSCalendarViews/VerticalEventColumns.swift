//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/01
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

public struct VerticalEventColumns: View {
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic
    @ObservedObject var viewModel: CalendarViewModel

    let dayRange: Range<Date> // days for display like 2022/Jan/01..<2022/Jan/08 (no care about time)
    let now: Date

    public init( _ viewModel: CalendarViewModel, dayRange: Range<Date>, now: Date) {
        self.viewModel = viewModel
        self.dayRange = dayRange
        self.now = now
    }

    public var body: some View {
        HStack(spacing: 0) {
            TimeColumn(viewModel: viewModel, date: now)
            ForEach(viewModel.eachDayRange(dayRange), id: \.self) { dayStart in
                Divider().foregroundColor(.white)
                EventColumn(viewModel: viewModel, date: dayStart)
            }
        }
        .overlay {
            NowTextLine(now: now)
                .offset(y: offsetY(now: now, oneHourHeight: heightDic["HourBlock"]))
        }
    }
    func offsetY(now: Date, oneHourHeight: CGFloat) -> CGFloat {
        let diffInTime = now.timeIntervalSinceReferenceDate - viewModel.midDate(now).timeIntervalSinceReferenceDate
        let diffInDot = diffInTime / CalendarViewModel.secInHour * oneHourHeight
        return diffInDot// - oneHourHeight * 0.5
    }
}
