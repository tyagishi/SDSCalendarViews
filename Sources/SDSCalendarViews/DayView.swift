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
    let now: Date
    public init( _ viewModel: CalendarViewModel, now: Date) {
        self.viewModel = viewModel
        self.now = now
    }
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.hourArray, id: \.self) { hour in
                HourBlock(hour, now)
                    .environmentObject(viewModel)
                    .id(CalendarViewModel.formattedHour(hour))
            }
        }
    }
}

struct HourBlock: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    let logger = Logger(subsystem: "com.smalldesksoftware.CalendarViews", category: "DayView.HourBlock")
    let blockStartInterval: TimeInterval
    let now: Date

    @State private var timeWidth: CGFloat = 10
    @State private var timeHeight: CGFloat = 10
    @State private var blockHeight: CGFloat = 10
    @State private var eventsWidth: CGFloat = 10

    init(_ start: TimeInterval, _ now: Date) {
        self.blockStartInterval = start
        self.now = now
    }
    var body: some View {
        // swiftlint:disable closure_body_length
        ZStack {
            HStack(spacing: 0) {
                Text("00:00")
                    .hidden()
                    .overlay {
                        Text(CalendarViewModel.formattedTime(blockStartInterval))
                    }
                    .readGeom { geomProxy in
                        timeHeight = geomProxy.size.height
                        timeWidth = geomProxy.size.width
                    }
                VStack { Divider() }.offset(y: timeHeight * 0.5 * (-1))
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    ForEach(viewModel.events.filter({ blockHourRange.contains($0.midInterval) })) { event in
                        RoundedRectangle(cornerRadius: 3).fill(event.color)
                            .frame(width: eventWidth(eventsWidth), height: eventHeight(event))
                            .overlay {
                                Text(event.title)
                                    .font(.footnote)
                                    .padding(2)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                            .help("\(CalendarViewModel.formattedTime(event.startInterval)) - \(CalendarViewModel.formattedTime(event.endInterval))")
                            .offset(x: eventOffsetX(event: event, eventsWidth),
                                    y: offsetY(event.midInterval - blockStartInterval, oneHourHeight: blockHeight))
                    }
                }
            }
            .readGeom { geomProxy in
                blockHeight = geomProxy.size.height
                eventsWidth = geomProxy.size.width - timeWidth
            }
            .overlay {
                if blockHourRange.contains(now.timeIntervalSinceReferenceDate) {
                    HStack(spacing: 0) {
                        NowLine(nowDate: now)
                    }
                    .offset(y: offsetY(now.timeIntervalSinceReferenceDate - blockStartInterval, oneHourHeight: blockHeight))
                }
            }
            .background(Color.gray.opacity(0.1))
        }
        // swiftlint:enable closure_body_length
    }

    func eventWidth(_ columnWidth: CGFloat) -> CGFloat {
        switch viewModel.layoutMode.eventWidth {
        case .fixed(let width):
            return width
        case .ratio(let ratio):
            return ratio * columnWidth
        }
    }

    func eventHeight(_ event: Event) -> CGFloat {
        // logger.log(level: .debug, "height for \(event.length) is \((viewSize.height) / 60.0 * event.length)  hourHeight is \(viewSize.height)")
        return blockHeight / CalendarViewModel.secInHour * event.length
    }

    func columnOffset(_ columnWidth: CGFloat) -> CGFloat {
        let refWidth = eventWidth(columnWidth)
        switch viewModel.layoutMode.alignMode {
        case .oneLine:
            return 0
        case .sideBySide:
            return refWidth
        case .shiftByRatio(let ratio):
            return refWidth * ratio
        case .shiftByPixel(let pixcel):
            return pixcel
        }
    }

    func eventOffsetX(event: Event, _ columnWidth: CGFloat) -> CGFloat {
        if let index = viewModel.events.firstIndex(where: { event.id == $0.id }) {
            let offset = columnOffset(eventWidth(columnWidth))
            return timeWidth + CGFloat(index) * offset
        }
        return timeWidth
    }

    func offsetY(_ diffFromStart: TimeInterval, oneHourHeight: CGFloat) -> CGFloat {
        let diffInDot = diffFromStart / CalendarViewModel.secInHour * oneHourHeight
        return diffInDot - oneHourHeight * 0.5
    }

    var blockHourRange: Range<TimeInterval> {
        blockStartInterval..<oneHourLater
    }

    var oneHourLater: TimeInterval {
        blockStartInterval + CalendarViewModel.secInHour
    }
}

struct NowLine: View {
    var nowDate: Date
    var body: some View {
        HStack {
            Text(CalendarViewModel.formattedTime(nowDate.timeIntervalSinceReferenceDate)).foregroundColor(.red).font(.caption)
            VStack {
                Divider().background(.red)
            }
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(CalendarViewModel.example(), now: Date())
    }
}
