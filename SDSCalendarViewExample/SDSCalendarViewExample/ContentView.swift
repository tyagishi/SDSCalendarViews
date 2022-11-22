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
        VStack {
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical){
                    DayView(calViewModel, now: dateProvider.date)
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
