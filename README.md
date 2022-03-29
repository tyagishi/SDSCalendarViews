# SDSCalendarViews

![platform](https://img.shields.io/badge/Platform-iOS-lightgrey)
![macOS iOS](https://img.shields.io/badge/platform-iOS_macOS-lightgrey)
![iOS](https://img.shields.io/badge/iOS-v15_orLater-blue)
![macOS](https://img.shields.io/badge/macOS-Monterey_orLater-blue)
![SPM is supported](https://img.shields.io/badge/SPM-Supported-orange)
![license](https://img.shields.io/badge/license-MIT-lightgrey)

view collection for Calendar

## DayView
View for calendar event in one day

### Screenshot
![text](https://user-images.githubusercontent.com/6419800/160526105-08385b6e-95ab-40b4-af52-2d9ea71d7ffa.png)

### Usage
use together with CalendarViewModel

```
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

```


