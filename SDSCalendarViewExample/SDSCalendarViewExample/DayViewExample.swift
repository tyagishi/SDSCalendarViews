//
//  DayViewExample.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/02
//  © 2023  SmallDeskSoftware
//

import SwiftUI
import SDSCalendarViews

struct DayViewExample: View {
    let dayLong:TimeInterval = 60 * 60 * 24
    @EnvironmentObject var viewModel: CalendarViewModel
    @StateObject var dateProvider = DateProvider()
    @State var date: Date = Date()
    let background = Color.gray.opacity(0.2)
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {date = date.advanced(by: -1 * dayLong)}, label: {
                    Image(systemName: "arrow.left")
                })
                Button(action: {date = date.advanced(by:dayLong)}, label: {
                    Image(systemName: "arrow.right")
                })
            }
            Text("DayView for \(CalendarViewModel.formattedDate(date))")
            HStack(spacing:0) {
                VStack(spacing: 0 ) {
                    Text("without Scroll (specified size: 200x1000)")
                    DayEventBlock(viewModel, date: date)
                    DayView(viewModel, date: date, now: dateProvider.date)
                }
                .background(background)
                .frame(width: 200)
                .frame(height: 1000)
                VStack(spacing: 0 ) {
                    Text("without Scroll (specified size: 200 width)")
                    DayEventBlock(viewModel, date: date)
                    DayView(viewModel, date: date, now: dateProvider.date)
                }
                .background(background)
                .frame(width: 200)
                VStack(spacing: 0 ) {
                    Text("with Scroll specified height: 1000 scrollView:200x600")
                    DayEventBlock(viewModel, date: date)
                    ScrollViewReader { scrollProxy in
                        ScrollView(.vertical) {
                            DayView(viewModel, date: date, now: dateProvider.date)
                                .frame(height: 1000)
                        }
                        .onAppear {
                            withAnimation {
                                scrollProxy.scrollTo(CalendarViewModel.formattedHour(Date()), anchor: .center)
                            }
                        }
                    }
                }
                .background(background)
                .frame(width: 200, height: 600)
            }
        }
    }
}


struct DayViewExample_Previews: PreviewProvider {
    static var previews: some View {
        DayViewExample()
            .environmentObject(CalendarViewModel.emptyExample(Date()))
    }
}
