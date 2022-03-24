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
    public init(_ viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        VStack(spacing:0) {
            ForEach(viewModel.hourArray, id: \.self) { hour in
                HourBlock(hour)
                    .environmentObject(viewModel)
            }
        }
    }
}

struct HourBlock: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    let logger = Logger(subsystem: "com.smalldesksoftware.CalendarViews", category: "DayView.HourBlock")
    let start: TimeInterval
    @State private var viewSize: CGSize = CGSize(width: 10, height: 10)
    @State private var timeWidth: CGFloat = 10

    init(_ start: TimeInterval) {
        self.start = start
    }
    var body: some View {
        ZStack {
            HStack(spacing:0) {
                Text("00:00")
                    .hidden()
                    .overlay {
                        Text(CalendarViewModel.formattedTime(start))
                            .offset(y: 5)
                    }
                    .readSize() { geomProxy in
                        timeWidth = geomProxy.size.width
                    }
                VStack { Divider() }
            }
            .frame(maxHeight: .infinity)
            .overlay(alignment: .leading) {
                HStack {
                    ForEach(viewModel.events.filter({blockHourRange.contains($0.midInterval)})) { event in
                        RoundedRectangle(cornerRadius: 3).fill(event.color)
                            .frame(width: eventWidth, height:  eventHeight(event))
                            .overlay{
                                Text(event.title)
                                    .font(.footnote)
                                    .padding(2)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                            .offset(x: eventOffsetX(event: event),
                                    y: eventOffsetY(event: event, oneHourHeight: viewSize.height))
                            .help("\(CalendarViewModel.formattedTime(event.startInterval)) - \(CalendarViewModel.formattedTime(event.endInterval))")
                    }
                }
            }
            .overlay {
                if blockHourRange.contains(Date().timeIntervalSinceReferenceDate) {
                    HStack(spacing:0) {
                        Rectangle().fill(.clear).frame(width: timeWidth)
                        NowLine(nowDate: viewModel.now)
                    }
                    .offset(y: nowOffsetY(date: Date(), oneHourHeight: viewSize.height))
                }
            }
        }
        .readSize(onChange: { geomProxy in
            viewSize = geomProxy.size
        })
    }

    var eventWidth: CGFloat {
        return (viewSize.width - timeWidth) / CGFloat(viewModel.events.count)
    }
    
    func eventHeight(_ event: Event) -> CGFloat {
        //logger.log(level: .debug, "height for \(event.lengthInMin) is \((viewSize.height) / 60.0 * event.lengthInMin)  hourHeight is \(viewSize.height)")
        return viewSize.height / 60.0 * event.lengthInMin
    }
    
    func calcedColumnWidth(_ columnWidth: CGFloat) -> CGFloat {
        switch viewModel.eventDisplayMode {
        case .oneLine:
            return 0
        case .sideBySide:
            return columnWidth
        case .shiftByRatio(let ratio):
            return columnWidth * ratio
        case .shiftByPixel(let pixcel):
            return pixcel
        }
    }
    
    func eventOffsetX(event: Event) -> CGFloat {
        if let index = viewModel.events.firstIndex(where: {event.id == $0.id}) {
            let offset = calcedColumnWidth(eventWidth)
            return timeWidth + CGFloat(index) * offset
        }
        return timeWidth
    }

    func eventOffsetY(event: Event, oneHourHeight: CGFloat) -> CGFloat {
        let diffInSec = event.midInterval - (start)
        let diffInMin = diffInSec / 60.0
        let diffInDot = diffInMin / 60 * oneHourHeight
        return diffInDot
    }

    func nowOffsetY(date: Date, oneHourHeight: CGFloat) -> CGFloat {
        let diffInSec = date.timeIntervalSinceReferenceDate - (start)
        let diffInMin = diffInSec / 60.0
        let diffInDot = diffInMin / 60 * oneHourHeight
        return diffInDot
    }

    var blockHourRange: Range<TimeInterval> {
        return start..<oneHourLater
    }
    
    var oneHourLater: TimeInterval {
        return start + 60 * 60
    }
    
}

struct NowLine: View {
    var nowDate: Date
    var body: some View {
        HStack {
            VStack {
                Divider().background(.red)
            }
            Text(CalendarViewModel.formattedTime(nowDate.timeIntervalSinceReferenceDate)).foregroundColor(.red).font(.caption)
            VStack {
                Divider().background(.red)
            }
        }
    }
}


struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(CalendarViewModel.example())
    }
}
