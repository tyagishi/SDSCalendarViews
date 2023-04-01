//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI
import SDSSwiftExtension

struct EventColumn: View {
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightsDic
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.hourRanges(date), id: \.self) { hourRange in
                HourBlock(viewModel, date, hourRange)
                    .frame(width: widthDic[CalendarViewModel.formattedDate(date)],
                           height: heightsDic["HourBlock"])
                    .id(CalendarViewModel.formattedHour(hourRange.lowerBound))
            }
        }
    }
}

struct EventColumn_Previews: PreviewProvider {
    static var previews: some View {
        EventColumn(viewModel: CalendarViewModel.emptyExample(Date()), date: Date())
    }
}
