//
//  VerticalDaysView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/02
//  © 2023  SmallDeskSoftware
//

import SwiftUI

public struct  VerticalDaysColumnWidthDicKey: EnvironmentKey {
    // note use "Date.distantPast" for TimeColumn width
    public typealias Value = [Date: CGFloat]
    static public var defaultValue: Value = [:]
}

extension EnvironmentValues {
    public var verticalDaysColumnWidthDicKey: [Date: CGFloat] {
        get {
            self[VerticalDaysColumnWidthDicKey.self]
        }
        set {
            self[VerticalDaysColumnWidthDicKey.self] = newValue
        }
    }
}

public struct VerticalDaysView: View {
    @Environment(\.verticalDaysColumnWidthDicKey) var widthDic
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
            let columnNum = CGFloat(dayNum + 1)
            GeometryReader { geom in
                let labelWidth = geom.size.width / columnNum
                let hourHeight = geom.size.height / (CGFloat(viewModel.endHour - viewModel.startHour))
                HStack(spacing: 0) {
                    // timeColumn (1 for whole view)
                    VStack {
                        Rectangle().fill(.blue).frame(CGSize(width: 50, height: 50))
                        TimeColumn(viewModel: viewModel, date: dayRange.lowerBound, labelWidth: labelWidth, hourHeight: hourHeight)
                    }
                    // event columns (1 for each day)
                    ForEach(viewModel.eachDayRange(dayRange), id: \.self) { dayStart in
                        Divider().foregroundColor(.white)
                        VStack {
                            EventColumnHeader(date: dayStart).frame(CGSize(width: 50, height: 50))
                            EventColumn(viewModel: viewModel, date: dayStart, hourHeight: hourHeight)
                        }
                    }
                }
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

extension View {
    public func eventColumnFontDic(_ fontDic: DictionaryWithDefault<Date, Font>) -> some View {
        self
            .environment(\.eventColumnFontDic, fontDic)
    }
    public func timeColumnFont(_ font: Font) -> some View {
        self
            .environment(\.timeColumnFont, font)
    }
    public func nowLineFont(_ font: Font) -> some View {
        self
            .environment(\.nowLineFont, font)
    }
}

struct DayRangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalDaysView(CalendarViewModel.example(),
                         dayRange: CalendarViewModel.oneWeekFrom(Date()), now: Date())
    }
}

public struct EventColumnHeader: View {
    @Environment(\.eventColumnFontDic) var fontDic: DictionaryWithDefault<Date, Font>
    let date: Date

    public init(date: Date) {
        self.date = date
    }

    public var body: some View {
        Text(date.formatted(.dateTime.month(.narrow).day())).font(fontDic[date])
    }
}
