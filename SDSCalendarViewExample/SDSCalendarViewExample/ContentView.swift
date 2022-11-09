//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2022/11/09
//  © 2022  SmallDeskSoftware
//

import SwiftUI
import SDSCalendarViews

struct ContentView: View {
    @StateObject var calViewModel = CalendarViewModel.example()
    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical){
                    DayView(calViewModel, now: Date())
                        .frame(width: 200)
                        .frame(height: 1000)
                }
                .onAppear {
                    withAnimation {
                        scrollProxy.scrollTo(CalendarViewModel.formattedHour(Date().timeIntervalSinceReferenceDate), anchor: .center)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
