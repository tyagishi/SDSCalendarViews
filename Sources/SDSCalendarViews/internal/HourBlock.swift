//
//  HourBlock.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI
import os

struct HourBlock: View {
    @Environment(\.eventColumnFontDic) var fontDic: DictionaryWithDefault<Date, Font>
    @ObservedObject var viewModel: CalendarViewModel
    let logger = Logger(subsystem: "com.smalldesksoftware.CalendarViews", category: "HourBlock")
    let blockHourRange: Range<Date>
    let date: Date

    let eventOffset: CGFloat = 10
    @State private var eventsWidth: CGFloat = 10

    init(_ viewModel: CalendarViewModel, _ date: Date, _ blockHourRange: Range<Date>) {
        self.viewModel = viewModel
        self.blockHourRange = blockHourRange
        self.date = date
    }
    var body: some View {
        let blockStartInterval = blockHourRange.lowerBound.timeIntervalSinceReferenceDate
        ZStack(alignment: .top) {
            VStack { Divider() }.frame(maxHeight: .infinity, alignment: .top)
            GeometryReader { eventAreaGeom in
                ForEach(viewModel.eventsFor(date, allDayEvent: false).filter({ blockHourRange.contains($0.midDate) })) { event in
                    RoundedRectangle(cornerRadius: 3).fill(event.color.opacity(0.3))
                        .frame(width: eventWidth(eventAreaGeom.size.width), height: eventHeight(event, eventAreaGeom.size.height))
                        .overlay {
                            Text(event.title)
                                .font(fontDic[date])
                                .padding(.leading, 5).padding(2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                        .overlay {
                            event.color.frame(width: 5).frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .clipped()
                        .help("\(CalendarViewModel.formattedTime(event.start)) - \(CalendarViewModel.formattedTime(event.end))\n" +
                              event.title)
                        .offset(x: eventOffsetX(event: event, eventsWidth),
                                y: offsetY(event.startInterval - blockStartInterval, oneHourHeight: eventAreaGeom.size.height))
                }
            }
        }
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
            return eventOffset + CGFloat(index) * offset
        }
        return eventOffset
    }

    func offsetY(_ diffFromStart: TimeInterval, oneHourHeight: CGFloat) -> CGFloat {
        let diffInDot = diffFromStart / CalendarViewModel.secInHour * oneHourHeight
        return diffInDot// - oneHourHeight * 0.5
    }
}

struct HourBlock_Previews: PreviewProvider {
    static var previews: some View {
        HourBlock(CalendarViewModel.exampleForWeekView(), Date(), CalendarViewModel.dateRange(Date(), -1, 2))
    }
}
