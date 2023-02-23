//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import Foundation

// MARK: example
extension CalendarViewModel {
    static public func example() -> CalendarViewModel {
        let layoutMode = (EventWidth.ratio(0.8), AlignMode.oneLine)
        let viewModel = CalendarViewModel(startHour: 8, endHour: 23,
                                          events: [ Event(title: "Daily", Self.todayAt(9, 0), Self.todayAt(10, 0), .red.opacity(0.6)),
                                                    Event(title: "Design", Self.todayAt(10, 30), Self.todayAt(11, 15), .blue.opacity(0.6)),
                                                    Event(title: "Lunch", Self.todayAt(12, 30), Self.todayAt(14), .brown.opacity(0.6)),
                                                    Event(title: "Meeting", Self.todayAt(15, 30), Self.todayAt(18, 45), .green.opacity(0.6)),
                                                    Event(title: "AllDayEvent", Self.todayAt(0, 0), Self.todayAt(23, 59), isAllDay: true, .cyan.opacity(0.6)),
                                                    Event(title: "Another Long AllDayEvent", Self.todayAt(0, 0), Self.todayAt(23, 59), isAllDay: true, .blue.opacity(0.6)),
                                                  ],
                                          layoutMode: layoutMode)
        //        viewModel.eventAlignMode = .shiftByRatio(80, ratio: 0.5)
        //        viewModel.eventAlignMode = .shiftByPixel(100, pixcel: 40)
        //        viewModel.eventAlignMode = .oneLine(250)
        return viewModel
    }

    static public func exampleForWeekView() -> CalendarViewModel {
        let layoutMode = (EventWidth.ratio(0.8), AlignMode.oneLine)

        let viewModel = CalendarViewModel(startHour: 8, endHour: 23,
                                          events: [ Event(title: "Daily", Self.todayAt(9, 0), Self.todayAt(10, 0), .red.opacity(0.6)),
                                                    Event(title: "Design", Self.todayAt(10, 30), Self.todayAt(11, 15), .blue.opacity(0.6)),
                                                    Event(title: "Lunch", Self.todayAt(12, 30), Self.todayAt(14), .brown.opacity(0.6)),
                                                    Event(title: "Meeting", Self.todayAt(15, 30), Self.todayAt(18, 45), .green.opacity(0.6)),
                                                    Event(title: "AllDayEvent", Self.todayAt(0, 0), Self.todayAt(23, 59), isAllDay: true, .cyan.opacity(0.6)),
                                                    Event(title: "Another Long AllDayEvent", Self.todayAt(0, 0), Self.todayAt(23, 59), isAllDay: true, .blue.opacity(0.6)),

                                                    Event(title: "Design -1", Self.dateAt(-1, 10, 30), Self.dateAt(-1, 11, 30), .blue.opacity(0.6)),
                                                    Event(title: "Lunch-1", Self.dateAt(-1, 12, 30), Self.dateAt(-1, 13, 30), .blue.opacity(0.6)),
                                                    Event(title: "Meeting-1", Self.dateAt(-1, 15, 30), Self.dateAt(-1, 18, 45), .green.opacity(0.6)),
                                                    Event(title: "AllDayEvent-1", Self.dateAt(-1, 0, 0), Self.dateAt(-1, 23, 59), isAllDay: true, .cyan.opacity(0.6)),
                                                    Event(title: "Another Long AllDayEvent-1", Self.dateAt(-1, 0, 0), Self.dateAt(-1, 23, 59), isAllDay: true, .blue.opacity(0.6)),

                                                    Event(title: "Design+1", Self.dateAt(+1, 10, 30), Self.dateAt(+1, 11, 30), .blue.opacity(0.6)),
                                                    Event(title: "Lunch+1", Self.dateAt(+1, 12, 30), Self.dateAt(+1, 13, 30), .blue.opacity(0.6)),
                                                    Event(title: "Meeting+1", Self.dateAt(+1, 15, 30), Self.dateAt(+1, 18, 45), .green.opacity(0.6)),
                                                    Event(title: "AllDayEvent+1", Self.dateAt(+1, 0, 0), Self.dateAt(+1, 23, 59), isAllDay: true, .cyan.opacity(0.6)),
                                                    Event(title: "Another Long AllDayEvent+1", Self.dateAt(+1, 0, 0), Self.dateAt(+1, 23, 59), isAllDay: true, .blue.opacity(0.6)),
                                                  ],
                                          layoutMode: layoutMode)

        //        viewModel.eventAlignMode = .shiftByRatio(80, ratio: 0.5)
        //        viewModel.eventAlignMode = .shiftByPixel(100, pixcel: 40)
        //        viewModel.eventAlignMode = .oneLine(250)
        return viewModel
    }

    static public func emptyExample(_ date: Date) -> CalendarViewModel {
        let layoutMode = (EventWidth.fixed(100), AlignMode.oneLine)
        let calViewModel = CalendarViewModel(startHour: 8, endHour: 23,
                                             layoutMode: layoutMode)
        return calViewModel
    }
}
