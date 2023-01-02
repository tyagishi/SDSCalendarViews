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
    let background: Color
    public init( _ viewModel: CalendarViewModel, now: Date, background: Color = .gray.opacity(0.1)) {
        self.viewModel = viewModel
        self.now = now
        self.background = background
    }
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.hourArray, id: \.self) { hour in
                HourBlock(hour, now)
                    .environmentObject(viewModel)
                    .id(CalendarViewModel.formattedHour(hour))
            }
        }
        .background(background)
    }
}

public struct DayEventView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let now: Date
    let background: Color
    public init( _ viewModel: CalendarViewModel, now: Date, background: Color = .gray.opacity(0.1)) {
        self.viewModel = viewModel
        self.now = now
        self.background = background
    }
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.events.filter({ $0.isAllDay == true })) { allDayEvent in
                Text(" " + allDayEvent.title)
                    .lineLimit(1).minimumScaleFactor(0.1)
                    .foregroundColor(allDayEvent.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(background)
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
        GeometryReader { blockGeom in
            HStack(alignment: .top, spacing: 0) {
                let timeLineOffsetY = (now.timeIntervalSinceReferenceDate - blockStartInterval) / CalendarViewModel.secInHour * blockGeom.size.height
                - blockGeom.size.height * 0.5
                VStack {
                    Text(CalendarViewModel.formattedTime(blockStartInterval))
                        .monospacedDigit()
                        .frame(maxHeight: .infinity, alignment: .top)
                        .overlay {
                            VStack {
                                if blockHourRange.contains(now.timeIntervalSinceReferenceDate) {
                                    NowText(nowDate: now)
                                        .offset(y: timeLineOffsetY)
                                }

                            }
                        }
                }
                ZStack(alignment: .top) {
                    VStack { Divider() }.frame(maxHeight: .infinity, alignment: .top)
                    GeometryReader { eventAreaGeom in
                        ForEach(viewModel.events.filter({ $0.isAllDay == false }).filter({ blockHourRange.contains($0.midInterval) })) { event in
                            RoundedRectangle(cornerRadius: 3).fill(event.color.opacity(0.3))
                                .frame(width: eventWidth(eventAreaGeom.size.width), height: eventHeight(event, eventAreaGeom.size.height))
                                .overlay {
                                    Text(event.title)
                                        .font(.footnote).bold()
                                        .padding(.leading, 5).padding(2)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                }
                                .overlay {
                                    event.color.frame(width: 5).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .clipped()
                                .help("\(CalendarViewModel.formattedTime(event.startInterval)) - \(CalendarViewModel.formattedTime(event.endInterval))\n" +
                                      event.title)
                                .offset(x: eventOffsetX(event: event, eventsWidth),
                                        y: offsetY(event.startInterval - blockStartInterval, oneHourHeight: eventAreaGeom.size.height))
                        }
                    }
                }
                .overlay {
                    VStack {
                        if blockHourRange.contains(now.timeIntervalSinceReferenceDate) {
                            NowLine(nowDate: now)
                                .offset(y: timeLineOffsetY)
                        }
                    }
                }
            }
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

    func eventHeight(_ event: Event, _ blockHeight: CGFloat) -> CGFloat {
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
        return diffInDot// - oneHourHeight * 0.5
    }

    var blockHourRange: Range<TimeInterval> {
        blockStartInterval..<oneHourLater
    }

    var oneHourLater: TimeInterval {
        blockStartInterval + CalendarViewModel.secInHour
    }
}

struct NowText: View {
    var nowDate: Date
    var body: some View {
        Text(CalendarViewModel.formattedTime(nowDate.timeIntervalSinceReferenceDate)).foregroundColor(.red).font(.caption)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct NowLine: View {
    var nowDate: Date
    var body: some View {
        VStack {
            Divider().background(.red)
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(CalendarViewModel.example(), now: Date())
    }
}
