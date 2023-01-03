//
//  DayEventBlock.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

public struct DayEventBlock: View {
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
    let background: Color
    public init( _ viewModel: CalendarViewModel, date: Date, background: Color = .gray.opacity(0.1)) {
        self.viewModel = viewModel
        self.date = date
        self.background = background
    }
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.allDayEventFor(date)) { allDayEvent in
                Text(" " + allDayEvent.title)
                    .lineLimit(1).minimumScaleFactor(0.1)
                    .foregroundColor(allDayEvent.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(background)
    }
}

struct DayEventBlock_Previews: PreviewProvider {
    static var previews: some View {
        DayEventBlock(CalendarViewModel.exampleForWeekView(), date: Date())
    }
}
