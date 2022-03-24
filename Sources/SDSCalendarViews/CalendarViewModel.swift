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
    public var lengthInMin: TimeInterval {
        return (endInterval - startInterval) / 60.0
    }
}

enum DisplayMode {
    case oneLine(_ width: CGFloat)
    case sideBySide(_ width: CGFloat)
    case shiftByRatio(_ width: CGFloat, ratio: CGFloat)
    case shiftByPixel(_ width: CGFloat, pixcel: CGFloat)
}

public class CalendarViewModel: ObservableObject {
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var events:[Event] = []
    @Published var now: Date
    
    var timerCancellable: AnyCancellable?

    // strategy how to put events in parallel (might be changed in the future, still under designing)
    @Published var eventDisplayMode: DisplayMode
    
    public init(start: Date, end: Date, events: [Event] = [], offset: CGFloat = -1) {
        self.startTime = start
        self.endTime = end
        self.events = events
        self.eventDisplayMode = .sideBySide(100)
        self.now = Date()
        timerCancellable = Timer.publish(every: 1, tolerance: 1, on: .main, in: .common, options: nil)
            .autoconnect()
            .sink(receiveValue: { newDate in
                self.now = Date()
            })
    }

    public var startTimeInterval: TimeInterval {
        startTime.timeIntervalSinceReferenceDate
    }
    public var endTimeInterval: TimeInterval {
        endTime.timeIntervalSinceReferenceDate
    }
    
    var hourArray: [TimeInterval] {
        return stride(from: startTimeInterval, through: endTimeInterval, by: 60*60).map{$0}
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
        viewModel.eventDisplayMode = .sideBySide(50)
        viewModel.eventDisplayMode = .shiftByRatio(80, ratio: 0.5)
        viewModel.eventDisplayMode = .shiftByPixel(100, pixcel: 40)
        viewModel.eventDisplayMode = .oneLine(250)
        return viewModel
    }
}

// MARK: formatter
extension CalendarViewModel {
    static public func formattedHour(_ interval: TimeInterval) -> String{
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let dateComp = Calendar.current.dateComponents([.hour], from: date)
        return String(format: "%2d:00", dateComp.hour!)
    }
    static public func formattedTime(_ interval: TimeInterval) -> String{
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let dateComp = Calendar.current.dateComponents([.hour, .minute], from: date)
        return String(format: "%02d:%02d", dateComp.hour!, dateComp.minute!)
    }
}
