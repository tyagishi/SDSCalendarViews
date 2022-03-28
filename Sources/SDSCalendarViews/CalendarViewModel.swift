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
    public var id: UUID
    public var title: String
    public var start: Date
    public var end: Date
    public var color: Color

    public init(_ title: String,_ start: Date,_ end: Date,_ color: Color = .gray.opacity(0.6)) {
        self.id = UUID()
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
        return (startInterval + endInterval) / 2.0
    }
    public var length: TimeInterval {
        return (endInterval - startInterval)
    }
    
    public func eventContainDate(_ date: Date) -> Bool {
        let range = ClosedRange(uncheckedBounds: (start,end))
        return range.contains(date)
    }
}

public enum EventWidth {
    case fixed(_ width: CGFloat)
    case ratio(_ ratio: CGFloat) // should be in (0,1)
}

public enum AlignMode {
    case oneLine
    case sideBySide
    case shiftByRatio(_ratio: CGFloat)
    case shiftByPixel(_ pixcel: CGFloat)
}

public typealias LayoutMode = (eventWidth: EventWidth, alignMode: AlignMode)
    
public extension CalendarViewModel {
    static let secInMin: CGFloat = 60.0
    static let secInHour: CGFloat = 60.0 * 60.0
    static let secInDay: CGFloat = 60.0 * 60.0 * 24.0
    
    static func todayAt(_ hour: Int) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
    }
}

public class CalendarViewModel: ObservableObject {
    @Published public private(set) var startDate: Date
    @Published public private(set) var endDate: Date
    @Published public private(set) var events:[Event] = []
    @Published var now: Date
    
    var timerCancellable: AnyCancellable?
    public var anyCancellables: Set<AnyCancellable> = Set()

    // strategy how to put events in parallel (might be changed in the future, still under designing)
    @Published public var layoutMode: LayoutMode// eventAlignMode: AlignMode
    
    public init(start: Date, end: Date, events: [Event] = [], layoutMode: LayoutMode = (.fixed(100), .sideBySide)) {
        self.startDate = start
        self.endDate = end
        self.events = events
        self.layoutMode = layoutMode
        self.now = Date()
        timerCancellable = Timer.publish(every: 1, tolerance: 1, on: .main, in: .common, options: nil)
            .autoconnect()
            .sink(receiveValue: { newDate in
                self.now = Date()
            })
    }

    public var startTimeInterval: TimeInterval {
        startDate.timeIntervalSinceReferenceDate
    }
    public var endTimeInterval: TimeInterval {
        endDate.timeIntervalSinceReferenceDate
    }
    
    nonisolated var hourArray: [TimeInterval] {
        return stride(from: startTimeInterval, through: endTimeInterval, by: CalendarViewModel.secInHour).map{$0}
    }
    
    @MainActor public func setStartEnd(_ start: Date,_ end: Date) {
        self.startDate = start
        self.endDate = end
    }
    
    @MainActor public func clearEvents() {
        self.events = []
    }
    
    @MainActor public func add(_ event: Event) {
        self.events.append(event)
    }
}

// MARK: example
extension CalendarViewModel {
    static public func example() -> CalendarViewModel {
        let viewModel = CalendarViewModel(start: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
                                          end: Calendar.current.date(bySettingHour: 22, minute: 59, second: 0, of: Date())!,
                                          events: [ Event("9:00-10:00",
                                                          Calendar.current.date(bySettingHour:  9, minute: 0, second: 0, of: Date())!,
                                                          Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
                                                          .red.opacity(0.6)),
                                                    Event("9:30-10:30",
                                                          Calendar.current.date(bySettingHour:  9, minute: 30, second: 0, of: Date())!,
                                                          Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date())!,
                                                          .blue.opacity(0.6)),
                                                    Event("9:30-15:30",
                                                          Calendar.current.date(bySettingHour:  9, minute: 30, second: 0, of: Date())!,
                                                          Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date())!,
                                                          .brown.opacity(0.6)),
                                                    Event("Event",
                                                          Calendar.current.date(bySettingHour: 10, minute: 15, second: 0, of: Date())!,
                                                          Calendar.current.date(bySettingHour: 21, minute: 45, second: 0, of: Date())!,
                                                          .green.opacity(0.6)),])
        viewModel.layoutMode = (.fixed(50), .sideBySide)
//        viewModel.eventAlignMode = .shiftByRatio(80, ratio: 0.5)
//        viewModel.eventAlignMode = .shiftByPixel(100, pixcel: 40)
//        viewModel.eventAlignMode = .oneLine(250)
        return viewModel
    }
    static public func emptyExample(_ date: Date) -> CalendarViewModel {
        let am8 = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: date)!
        let pm10 = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: date)!
        let calViewModel = CalendarViewModel(start: am8, end: pm10)
        calViewModel.layoutMode = (.fixed(100), .oneLine)
        return calViewModel
    }
}

// MARK: formatter
extension CalendarViewModel {
    static public func formattedDate(_ interval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%4d/%02d/%02d", dateComp.year!, dateComp.month!, dateComp.day!)
    }
    static public func formattedHour(_ interval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let dateComp = Calendar.current.dateComponents([.hour], from: date)
        return String(format: "%2d:00", dateComp.hour!)
    }
    static public func formattedTime(_ interval: TimeInterval) -> String{
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let dateComp = Calendar.current.dateComponents([.hour, .minute], from: date)
        return String(format: "%02d:%02d", dateComp.hour!, dateComp.minute!)
    }
    static public func formattedLength(_ interval: TimeInterval) -> String {
        let hour = Int(interval / CalendarViewModel.secInHour)
        let min = Int( (interval - Double(hour) * CalendarViewModel.secInHour ) / CalendarViewModel.secInMin)
        return String(format: "%02d:%02d", hour, min)
    }
}
