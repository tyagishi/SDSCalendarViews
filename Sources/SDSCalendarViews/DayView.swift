//
//  DayView.swift
//
//  Created by : Tomoaki Yagishita on 2022/03/23
//  © 2022  SmallDeskSoftware
//

import SwiftUI
import os
import SDSViewExtension
import Combine

public struct DayView: View {
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
    let now: Date

    public init( _ viewModel: CalendarViewModel, date: Date, now: Date) {
        self.viewModel = viewModel
        self.date = date
        self.now = now
    }
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Rectangle().fill(.clear)
                    .frame(width: widthDic["TimeColumn"], height: 0.1)
                EventColumnHeader(date: date,
                                  label: { Text(date.formatted(.dateTime.month(.twoDigits).day(.twoDigits))).frame(maxWidth: .infinity, alignment: .center) })
                .frame(width: widthDic[CalendarViewModel.formattedDate(date)])
//                EventColumnHeader(date: date, title: date.formatted(Date.FormatStyle.dateTime.day(.twoDigits).month(.twoDigits)))
            }
            HStack(spacing: 0) {
                TimeColumn(viewModel: viewModel, date: date)
                EventColumn(viewModel: viewModel, date: date)
            }
            .overlay {
                if date.dayLongRange.contains(now) {
                    NowTextLine(now: now)
                        .offset(y: offsetY(now: now, oneHourHeight: heightDic["HourBlock"]))
                }
            }
        }
    }

    func offsetY(now: Date, oneHourHeight: CGFloat) -> CGFloat {
        let diffInTime = now.timeIntervalSinceReferenceDate - viewModel.midDate(now).timeIntervalSinceReferenceDate
        let diffInDot = diffInTime / CalendarViewModel.secInHour * oneHourHeight
        return diffInDot// - oneHourHeight * 0.5
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(CalendarViewModel.example(), date: Date(), now: Date())
    }
}
