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
    @Environment(\.calendarViewAlignmentDic) var alignmentDic
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
    let now: Date

    let dayLabelKey = CalendarDicKey.dayLabel.rawValue
    let timeColumnKey = CalendarDicKey.timeColumn.rawValue
    let hourBlockKey = CalendarDicKey.hourBlock.rawValue

    public init( _ viewModel: CalendarViewModel, date: Date, now: Date) {
        self.viewModel = viewModel
        self.date = date
        self.now = now
    }
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TimeColumnLabel()
                EventColumnHeader(date: date,
                                  label: { Text(date.formatted(.dateTime.month(.twoDigits).day(.twoDigits)))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignmentDic[dayLabelKey])
                })
            }
            HStack(spacing: 0) {
                TimeColumnEventLabel()
                DayEventBlock(viewModel, date: date)
            }
            HStack(spacing: 0) {
                TimeColumn(viewModel: viewModel, date: date)
                EventColumn(viewModel: viewModel, date: date)
            }
            .overlay {
                if date.dayLongRange.contains(now) {
                    NowTextLine(now: now)
                        .offset(y: offsetY(now: now, oneHourHeight: heightDic[hourBlockKey]))
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
