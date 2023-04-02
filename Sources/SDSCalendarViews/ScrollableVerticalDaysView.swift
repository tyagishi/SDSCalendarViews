//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/02
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

public struct ScrollableVerticalDaysView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let dayRange: Range<Date> // days for display like 2022/Jan/01..<2022/Jan/08 (no care about time)
    let now: Date

    public init(_ viewModel: CalendarViewModel, dayRange: Range<Date>, now: Date) {
        self.viewModel = viewModel
        self.dayRange = dayRange
        self.now = now
    }

    public var body: some View {
        ScrollViewEx(header: {
            HStack(spacing: 0) {
                TimeColumnHeader().border(.red)
                ForEach(viewModel.eachDayRange(dayRange), id: \.self) { date in
                    VStack(spacing: 0) {
                        EventColumnHeader(date: date, label: { Text(CalendarViewModel.formattedMMDD(date)) })
                            .border(.red)
                        DayEventBlock(viewModel, date: date)
                            .border(.red)
                    }
                }
            }}, content: {
                VerticalEventColumns(viewModel, dayRange: dayRange, now: Date())
            }, footer: { EmptyView() })
    }
}

struct ScrollViewEx<Header: View, Content: View, Footer: View>: View {
    let header: Header
    let content: Content
    let footer: Footer

    init(@ViewBuilder header: () -> Header,
         @ViewBuilder content: () -> Content,
         @ViewBuilder footer: () -> Footer) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }
    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                content
            }
            footer
        }
    }
}
