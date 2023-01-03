//
//  VerticalDaysViewExample.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI
import SDSCalendarViews

struct VerticalDaysViewExample: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    let dayRange = CalendarViewModel.dateRange(Date(), -2, +4)
    public var body: some View {
        HStack {
            VStack {
                Text("without scroll")
                VerticalDaysView(viewModel, dayRange: dayRange, now: Date())
                    .frame(height: 1000)
            }
            ScrollView {
                Text("with scroll")
                VerticalDaysView(viewModel, dayRange: dayRange, now: Date())
                    .frame(height: 1000)
            }
            .frame(height: 800)
            .border(.red)
        }
    }
}

struct VerticalDaysViewExample_Previews: PreviewProvider {
    static var previews: some View {
        VerticalDaysViewExample()
            .environmentObject(CalendarViewModel.emptyExample(Date()))
    }
}
