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
                    .id(CalendarViewModel.formattedHour(hour))
            }
        }
    }
}

struct HourBlock: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    let logger = Logger(subsystem: "com.smalldesksoftware.CalendarViews", category: "DayView.HourBlock")
    let blockStartInterval: TimeInterval

    @State private var timeWidth: CGFloat = 10
    @State private var timeHeight: CGFloat = 10
    @State private var blockHeight: CGFloat = 10
    
    init(_ start: TimeInterval) {
        self.blockStartInterval = start
    }
    var body: some View {
        ZStack {
            HStack(spacing:0) {
                Text("00:00")
                    .hidden()
                    .overlay {
                        Text(CalendarViewModel.formattedTime(blockStartInterval))
                    }
                    .readGeom() { geomProxy in
                        timeHeight = geomProxy.size.height
                        timeWidth = geomProxy.size.width
                    }
                VStack { Divider() }.offset(y: timeHeight * 0.5 * (-1))
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .leading) {
                ZStack(alignment: .topLeading){
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
                                    y: offsetY(event.midInterval - blockStartInterval, oneHourHeight: blockHeight))
                            .help("\(CalendarViewModel.formattedTime(event.startInterval)) - \(CalendarViewModel.formattedTime(event.endInterval))")
                    }
                }
            }
            .readGeom { geomProxy in
                blockHeight = geomProxy.size.height
            }
            .overlay {
                if blockHourRange.contains(Date().timeIntervalSinceReferenceDate) {
                    HStack(spacing:0) {
                        NowLine(nowDate: viewModel.now)
                    }
                    .offset(y: offsetY(Date().timeIntervalSinceReferenceDate - blockStartInterval, oneHourHeight: blockHeight))
                }
            }
            .background(Color.gray.opacity(0.1))
        }
    }
    
    var eventWidth: CGFloat {
        switch viewModel.eventAlignMode {
        case .oneLine(let width):
            return width
        case .sideBySide(let width):
            return width
        case .shiftByRatio(let width,_):
            return width
        case .shiftByPixel(let width,_):
            return width
        }
    }
    
    func eventHeight(_ event: Event) -> CGFloat {
        //logger.log(level: .debug, "height for \(event.length) is \((viewSize.height) / 60.0 * event.length)  hourHeight is \(viewSize.height)")
        return blockHeight / CalendarViewModel.secInHour * event.length
    }
    
    func columnOffset(_ columnWidth: CGFloat) -> CGFloat {
        switch viewModel.eventAlignMode {
        case .oneLine(_):
            return 0
        case .sideBySide(let width):
            return width
        case .shiftByRatio(let width, let ratio):
            return width * ratio
        case .shiftByPixel(_, let pixcel):
            return pixcel
        }
    }
    
    func eventOffsetX(event: Event) -> CGFloat {
        if let index = viewModel.events.firstIndex(where: {event.id == $0.id}) {
            let offset = columnOffset(eventWidth)
            return timeWidth + CGFloat(index) * offset
        }
        return timeWidth
    }
    
    func offsetY(_ diffFromStart: TimeInterval, oneHourHeight: CGFloat) -> CGFloat {
        let diffInDot = diffFromStart / CalendarViewModel.secInHour * oneHourHeight
        return diffInDot - oneHourHeight * 0.5
    }
    
    var blockHourRange: Range<TimeInterval> {
        return blockStartInterval..<oneHourLater
    }
    
    var oneHourLater: TimeInterval {
        return blockStartInterval + CalendarViewModel.secInHour
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
        DayView(CalendarViewModel.example())
    }
}
