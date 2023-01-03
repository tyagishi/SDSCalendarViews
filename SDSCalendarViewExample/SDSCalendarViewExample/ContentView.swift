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
    @StateObject var viewModel = CalendarViewModel.exampleForWeekView()  //CalendarViewModel.example()
    var body: some View {
        TabView {
            DayViewExample()
                .tabItem {
                    Label("DayView", systemImage: "d.square.fill")
                }
                .environmentObject(viewModel)
            VerticalDaysViewExample()
                .tabItem {
                    Label("WeekView", systemImage: "w.square.fill")
                }
                .environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



