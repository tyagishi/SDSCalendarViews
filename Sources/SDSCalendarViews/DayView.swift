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
    let background: Color
    let showTime: Bool
    public init( _ viewModel: CalendarViewModel, date: Date, now: Date, background: Color = .gray.opacity(0.1),
                 showTime: Bool = true) {
        self.viewModel = viewModel
        self.date = date
        self.now = now
        self.background = background
        self.showTime = showTime
    }
    public var body: some View {
        GeometryReader { geom in
            let labelWidth = geom.size.width * 0.25
            let eventWidth = geom.size.width * 0.75
            let hourHeight = geom.size.height / (CGFloat(viewModel.endHour - viewModel.startHour))
            HStack(spacing: 0) {
                TimeColumn(viewModel: viewModel, date: date, labelWidth: labelWidth, hourHeight: hourHeight)
                EventColumn(viewModel: viewModel, date: date, now: now, eventWidth: eventWidth, hourHeight: hourHeight)
            }
            .overlay {
                if date.dayLongRange.contains(now) {
                    NowTextLine(now: now, labelWidth: labelWidth)
                        .offset(y: offsetY(now: now, oneHourHeight: hourHeight))
                }
            }
            .background(background)
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
