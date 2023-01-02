//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2022/11/09
//  © 2022  SmallDeskSoftware
//

import SwiftUI
import SDSCalendarViews
import Combine

class DateProvider: ObservableObject {
    @Published var date: Date = Date()
    var cancellables: Set<AnyCancellable> = Set()

    init() {
        Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
            .autoconnect()
            .sink { value in
                self.date = value
            }
            .store(in: &cancellables)
    }

}

struct ContentView: View {
    @StateObject var calViewModel = CalendarViewModel.example()
    @StateObject var dateProvider = DateProvider()
    var body: some View {
        VStack(spacing: 0) {
            DayEventView(calViewModel, now: dateProvider.date, background: .red.opacity(0.1))
                .frame(width: 216) // for macOS. it should be 200 for iOS
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical){
                    DayView(calViewModel, now: dateProvider.date, background: .yellow.opacity(0.2))
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
        .frame(width: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
