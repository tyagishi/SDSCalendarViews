//
//  VerticalDaysView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/02
//  © 2023  SmallDeskSoftware
//

import SwiftUI
import SDSSwiftExtension

public struct VerticalDaysView: View {
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic
    @ObservedObject var viewModel: CalendarViewModel
    let dayRange: Range<Date> // days for display like 2022/Jan/01..<2022/Jan/08 (no care about time)
    let now: Date

    public init( _ viewModel: CalendarViewModel, dayRange: Range<Date>,
                 now: Date) {
        self.viewModel = viewModel
        self.dayRange = dayRange
        self.now = now
    }
    public var body: some View {
        HStack(spacing: 0) {
            // timeColumn (1 for whole view)
            VStack(spacing: 0) {
                TimeColumnHeader()
                TimeColumn(viewModel: viewModel, date: dayRange.lowerBound)
            }
            // event columns (1 for each day)
            ForEach(viewModel.eachDayRange(dayRange), id: \.self) { date in
                Divider().foregroundColor(.white)
                VStack(spacing: 0) {
                    EventColumnHeader(date: date,
                                      label: { Text( date.formatted(.dateTime.month(.twoDigits).day(.twoDigits))) })
                    EventColumn(viewModel: viewModel, date: date)
                }
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
