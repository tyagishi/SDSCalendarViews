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
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
    let now: Date

    public init( _ viewModel: CalendarViewModel, date: Date, now: Date) {
        self.viewModel = viewModel
        self.date = date
        self.now = now
    }
    public var body: some View {
        GeometryReader { geom in
            let labelWidth = geom.size.width * 0.25
            let hourHeight = geom.size.height / (CGFloat(viewModel.endHour - viewModel.startHour))
            HStack(spacing: 0) {
                TimeColumn(viewModel: viewModel, date: date, labelWidth: labelWidth, hourHeight: hourHeight)
                EventColumn(viewModel: viewModel, date: date, hourHeight: hourHeight)
            }
            .overlay {
                if date.dayLongRange.contains(now) {
                    NowTextLine(now: now, labelWidth: labelWidth)
                        .offset(y: offsetY(now: now, oneHourHeight: hourHeight))
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
