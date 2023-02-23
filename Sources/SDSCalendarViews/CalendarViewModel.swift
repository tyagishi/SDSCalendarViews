//
//  CalendarViewModel.swift
//
//  Created by : Tomoaki Yagishita on 2022/03/23
//  © 2022  SmallDeskSoftware
//

import Foundation
import Combine
import SwiftUI

extension Date {
    public var dayLongRange: Range<Date> {
        let start = Calendar.current.startOfDay(for: self)
        let end = Calendar.current.startOfDay(for: self).addingTimeInterval(CalendarViewModel.secInDay)
        return start..<end
    }
}

public struct Event: Identifiable {
    public var id: String // store calendarItemIdentifier in case of EKEvent
    public var title: String
    public var start: Date
    public var end: Date
    public var color: Color
    public var isAllDay: Bool

    public init(_ id: String = UUID().uuidString, title: String, _ start: Date, _ end: Date, isAllDay: Bool = false, _ color: Color = .gray.opacity(0.6)) {
        self.id = id
        self.title = title
        self.start = start
        self.end = end
        self.isAllDay = isAllDay
        self.color = color
    }

    public var startInterval: TimeInterval {
        start.timeIntervalSinceReferenceDate
    }
    public var endInterval: TimeInterval {
        end.timeIntervalSinceReferenceDate
    }

    public var midInterval: TimeInterval {
        (startInterval + endInterval) / 2.0
    }

    public var midDate: Date {
        let midInterval = (start.timeIntervalSinceReferenceDate + end.timeIntervalSinceReferenceDate) / 2.0
        return Date(timeIntervalSinceReferenceDate: midInterval)
    }

    public var length: TimeInterval {
        end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
    }

    public func eventContainDate(_ date: Date) -> Bool {
        let range = ClosedRange(uncheckedBounds: (start, end))
        return range.contains(date)
    }
}

/// strategy for deciding event width
public enum EventWidth {
    /// fixed width
    ///
    /// use given width for event width
    case fixed(_ width: CGFloat)
    /// use ratio from whole width which can be used for calendar
    ///
    /// ex: 0.5 means one event will occupy 50% of calendar width
    case ratio(_ ratio: CGFloat) // should be in (0,1)
}

/// strategy for putting events on calendar
///
/// decide how to put events on calendar view
public enum AlignMode {
    /// put all events along one vertical line
    case oneLine
    /// put events side by side
    case sideBySide
    /// put events with shifting in horizontal direction with ratio of event width
    case shiftByRatio(_ ratio: CGFloat)
    /// put events with shifting in horizontal direction with specified pixel
    case shiftByPixel(_ pixcel: CGFloat)
}

/// layout strategy for putting events on calendar
public typealias LayoutMode = (eventWidth: EventWidth, alignMode: AlignMode)

public extension CalendarViewModel {
    static let secInMin: CGFloat = 60.0
    static let secInHour: CGFloat = 60.0 * 60.0
    static let secInDay: CGFloat = 60.0 * 60.0 * 24.0

    static func todayAt(_ hour: Int, _ minute: Int = 0) -> Date {
        // swiftlint:disable:next force_unwrapping
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }
    static func dateAt(_ dayOffset: Int, _ hour: Int, _ minute: Int = 0) -> Date {
        let advance = CalendarViewModel.secInDay * CGFloat(dayOffset)
        let theDay = Calendar.current.startOfDay(for: Date()).advanced(by: advance)
        // swiftlint:disable:next force_unwrapping
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: theDay)!
    }
}

/// ViewModel for CalendarViews(DayView/WeekView/MonthView in SDSCalendarViews)
public class CalendarViewModel: ObservableObject {
    // views will show startHour..<endHour range
    @Published public private(set) var startHour: Int // i.e. from startHour:00:00
    @Published public private(set) var endHour: Int   // i.e. till (endHour-1):59:59

    /// events which will be shown on view
    /// note: might have allDayEvent
    @Published public private(set) var events: [Event] = []

    /// strategy how to put events in parallel (might be changed in the future, still under designing)
    public let layoutMode: LayoutMode// eventAlignMode: AlignMode

    let timeLabelWidth: CGFloat = 0

    public init(startHour: Int, endHour: Int, events: [Event] = [], layoutMode: LayoutMode = (.fixed(100), .sideBySide)) {
        self.startHour = startHour
        self.endHour = endHour

        self.events = events
        self.layoutMode = layoutMode
    }

    public func startDate(_ date: Date) -> Date {
        // swiftlint:disable force_unwrapping
        Calendar.current.date(bySettingHour: startHour, minute: 0, second: 0, of: date)!
    }
    public func endDate(_ date: Date) -> Date {
        // swiftlint:disable force_unwrapping
        Calendar.current.date(bySettingHour: endHour - 1, minute: 59, second: 59, of: date)!
    }

    public func oneHourRange(_ date: Date, startHour: Int) -> Range<Date> {
        // swiftlint:disable force_unwrapping
        let start = Calendar.current.date(bySettingHour: startHour, minute: 0, second: 0, of: date)!

        let endHour = min(startHour + 1, 23)
        // swiftlint:disable force_unwrapping
        let end = Calendar.current.date(bySettingHour: endHour, minute: 59, second: 59, of: date)!
        return start..<end
    }

    public func hourRanges(_ date: Date) -> [Range<Date>] {
        (startHour..<endHour).map({ self.oneHourRange(date, startHour: $0) })
    }

    public func midDate(_ date: Date) -> Date {
        let midInterval = (startDate(date).timeIntervalSinceReferenceDate + endDate(date).timeIntervalSinceReferenceDate) / 2.0
        return Date(timeIntervalSinceReferenceDate: midInterval)
    }

    @MainActor public func clearEvents() async {
        self.events = []
    }

    @MainActor public func add(_ event: Event) async {
        if let firstIndex = events.firstIndex(where: { $0.id == event.id }) {
            // already existing event
            events[firstIndex] = event
        } else {
            self.events.append(event)
        }
    }
    public func eventsFor(_ date: Date, allDayEvent: Bool = false) -> [Event] {
        let dayRange = date.dayLongRange
        return events.filter({ $0.isAllDay == false }).filter({ ($0.start..<$0.end).overlaps(dayRange) })
    }
    public func allDayEventFor(_ date: Date) -> [Event] {
        let dayRange = date.dayLongRange
        return events.filter({ $0.isAllDay == true }).filter({ ($0.start..<$0.end).overlaps(dayRange) })
    }

}

extension CalendarViewModel {
    public func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

// MARK: convenient method for Range<Date>
extension CalendarViewModel {
    static public func oneWeekFrom(_ date: Date) -> Range<Date> {
        Date()..<(Date().advanced(by: CalendarViewModel.secInDay * 7))
    }

    /// generate Range<Date> from given info
    /// - Parameters:
    ///   - date: reference date
    ///   - from: start offset days relative to reference date (0: from today, -1: from yesterday) at 0:00
    ///   - to: end offset days relative to reference date (1: until tomorrow(incl)) 
    /// - Returns: startDate..<endDate>
    static public func dateRange(_ date: Date, _ from: Int, _ to: Int) -> Range<Date> {

        let startDay = Calendar.current.startOfDay(for: date).advanced(by: CalendarViewModel.secInDay * CGFloat(from))
        let endDay = Calendar.current.startOfDay(for: date).advanced(by: CalendarViewModel.secInDay * CGFloat(to + 1))
        return startDay..<endDay
    }
//    static public func oneWeekFromMonday(_ date: Date) -> Range<Date> {
//        let monday = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date!
//        let monday = Calendar.current.dateInterval(of: .weekOfYear, for: <#T##Date#>)
//    }

    public func eachDayRange(_ range: Range<Date>, stride: TimeInterval = CalendarViewModel.secInDay) -> [Date] {
        var ret: [Date] = []

        var date = range.lowerBound
        ret.append(date)
        while date.timeIntervalSinceReferenceDate + stride < range.upperBound.timeIntervalSinceReferenceDate {
            date += stride
            ret.append(date)
        }
        return ret
    }

}

// MARK: formatter
extension CalendarViewModel {
    static public func formattedDate(_ date: Date) -> String {
        let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: date)
        // swiftlint:disable:next force_unwrapping
        return String(format: "%4d/%02d/%02d", dateComp.year!, dateComp.month!, dateComp.day!)
    }
    static public func formattedHour(_ date: Date) -> String {
        let dateComp = Calendar.current.dateComponents([.hour], from: date)
        // swiftlint:disable:next force_unwrapping
        return String(format: "%2d:00", dateComp.hour!)
    }
    static public func formattedTime(_ date: Date) -> String {
        let dateComp = Calendar.current.dateComponents([.hour, .minute], from: date)
        // swiftlint:disable:next force_unwrapping
        return String(format: "%02d:%02d", dateComp.hour!, dateComp.minute!)
    }
    static public func formattedLength(_ interval: TimeInterval) -> String {
        let hour = Int(interval / CalendarViewModel.secInHour)
        let min = Int( (interval - Double(hour) * CalendarViewModel.secInHour ) / CalendarViewModel.secInMin)
        return String(format: "%02d:%02d", hour, min)
    }
}
