//
//  VerticalDaysView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/02
//  © 2023  SmallDeskSoftware
//

import SwiftUI

public struct VerticalDaysView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let dayRange: Range<Date> // days for display like 2022/Jan/01..<2022/Jan/08 (no care about time)
    let now: Date
    let background: Color
    let dayLong = 60 * 60 * 24
    public init( _ viewModel: CalendarViewModel, dayRange: Range<Date>,
                 now: Date, background: Color = .gray.opacity(0.1)) {
        self.viewModel = viewModel
        self.dayRange = dayRange
        self.now = now
        self.background = background
    }
    public var body: some View {
        HStack(spacing: 0) {
            let columnNum = CGFloat(dayNum + 1)
            GeometryReader { geom in
                let labelWidth = geom.size.width / columnNum
                let eventWidth = geom.size.width / columnNum
                let hourHeight = geom.size.height / (CGFloat(viewModel.endHour - viewModel.startHour))
                HStack(spacing: 0) {
                    TimeColumn(viewModel: viewModel, date: dayRange.lowerBound, labelWidth: labelWidth, hourHeight: hourHeight)
                    ForEach(viewModel.eachDayRange(dayRange), id: \.self) { dayStart in
                        Divider().foregroundColor(.black)
                        VStack {
                            EventColumn(viewModel: viewModel, date: dayStart, now: now, eventWidth: eventWidth, hourHeight: hourHeight)
                        }
                    }
                }
                .background(background)
                .overlay {
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

    var dayNum: Int {
        let start = Calendar.current.startOfDay(for: dayRange.lowerBound)
        let end = Calendar.current.startOfDay(for: dayRange.upperBound)
        return Int((end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate) / CalendarViewModel.secInDay)
    }
}

struct DayRangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalDaysView(CalendarViewModel.example(),
                         dayRange: CalendarViewModel.oneWeekFrom(Date()), now: Date())
    }
}
