//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

struct EventColumn: View {
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
    let now: Date
    let eventWidth: CGFloat
    let hourHeight: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.hourRanges(date), id: \.self) { hourRange in
                HourBlock(viewModel, date, hourRange)
                    .frame(height: hourHeight)
                    .environmentObject(viewModel)
                    .id(CalendarViewModel.formattedHour(hourRange.lowerBound))
            }
        }
    }
}

struct EventColumn_Previews: PreviewProvider {
    static var previews: some View {
        EventColumn(viewModel: CalendarViewModel.emptyExample(Date()), date: Date(), now: Date(), eventWidth: 100, hourHeight: 80)
    }
}
