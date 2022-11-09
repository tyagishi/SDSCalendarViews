//
//  CalendarViewModel.swift
//
//  Created by : Tomoaki Yagishita on 2022/03/23
//  © 2022  SmallDeskSoftware
//

import Foundation
import Combine
import SwiftUI

public struct Event: Identifiable {
    public var id: String // store calendarItemIdentifier in case of EKEvent
    public var title: String
    public var start: Date
    public var end: Date
    public var color: Color

    public init(_ id: String = UUID().uuidString, title: String, _ start: Date, _ end: Date, _ color: Color = .gray.opacity(0.6)) {
        self.id = id
        self.title = title
        self.start = start
        self.end = end
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
    public var length: TimeInterval {
        (endInterval - startInterval)
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
}

/// ViewModel for DayView
public class CalendarViewModel: ObservableObject {
    /// start date of view covers
    @Published public private(set) var startDate: Date
    /// end date of view covers
    @Published public private(set) var endDate: Date
    /// events which will be shown on view
    @Published public private(set) var events: [Event] = []

    /// strategy how to put events in parallel (might be changed in the future, still under designing)
    public let layoutMode: LayoutMode// eventAlignMode: AlignMode

    let timeLabelWidth: CGFloat = 0

    public init(start: Date, end: Date, events: [Event] = [], layoutMode: LayoutMode = (.fixed(100), .sideBySide)) {
        self.startDate = start
        self.endDate = end
        self.events = events
        self.layoutMode = layoutMode
    }

    public var startTimeInterval: TimeInterval {
        startDate.timeIntervalSinceReferenceDate
    }
    public var endTimeInterval: TimeInterval {
        endDate.timeIntervalSinceReferenceDate
    }

    var hourArray: [TimeInterval] {
        Array(stride( from: startTimeInterval, through: endTimeInterval, by: CalendarViewModel.secInHour))
    }

    @MainActor public func setStartEnd(_ start: Date, _ end: Date) {
        self.startDate = start
        self.endDate = end
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
}

// MARK: example
extension CalendarViewModel {
    static public func example() -> CalendarViewModel {
        let layoutMode = (EventWidth.ratio(0.8), AlignMode.oneLine)
        let viewModel = CalendarViewModel(start: Self.todayAt(8), end: Self.todayAt(22, 59),
                                          events: [ Event(title: "Daily", Self.todayAt(9, 0), Self.todayAt(10, 0), .red.opacity(0.6)),
                                                    Event(title: "Design", Self.todayAt(10, 30), Self.todayAt(11, 15), .blue.opacity(0.6)),
                                                    Event(title: "Lunch", Self.todayAt(12, 30), Self.todayAt(14), .brown.opacity(0.6)),
                                                    Event(title: "Meeting", Self.todayAt(15, 30), Self.todayAt(18, 45), .green.opacity(0.6))],
                                          layoutMode: layoutMode)

//        viewModel.eventAlignMode = .shiftByRatio(80, ratio: 0.5)
//        viewModel.eventAlignMode = .shiftByPixel(100, pixcel: 40)
//        viewModel.eventAlignMode = .oneLine(250)
        return viewModel
    }
    static public func emptyExample(_ date: Date) -> CalendarViewModel {
        let layoutMode = (EventWidth.fixed(100), AlignMode.oneLine)
        let calViewModel = CalendarViewModel(start: Self.todayAt(8), end: Self.todayAt(22, 59), layoutMode: layoutMode)
        return calViewModel
    }
}

// MARK: formatter
extension CalendarViewModel {
    static public func formattedDate(_ interval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: date)
        // swiftlint:disable:next force_unwrapping
        return String(format: "%4d/%02d/%02d", dateComp.year!, dateComp.month!, dateComp.day!)
    }
    static public func formattedHour(_ interval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let dateComp = Calendar.current.dateComponents([.hour], from: date)
        // swiftlint:disable:next force_unwrapping
        return String(format: "%2d:00", dateComp.hour!)
    }
    static public func formattedTime(_ interval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: interval)
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
