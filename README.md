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
                        scrollProxy.scrollTo(CalendarViewModel.formattedHour(Date()), anchor: .center)
                    }
                }
            }
        }
    }
}

```

### ViewModel
```
/// ViewModel for CalendarViews(DayView/WeekView/MonthView in SDSCalendarViews)
public class CalendarViewModel: ObservableObject {
    // views will show startHour...endHour range
    @Published public private(set) var startHour: Int
    @Published public private(set) var endHour: Int

    /// events which will be shown on view
    /// note: might have allDayEvent
    @Published public private(set) var events: [Event] = []

    /// strategy how to put events in parallel (might be changed in the future, still under designing)
    public let layoutMode: LayoutMode// eventAlignMode: AlignMode

    let timeLabelWidth: CGFloat = 0
    ...
}
public struct Event: Identifiable {
    public var id: String // store calendarItemIdentifier in case of EKEvent, otherwise UUID().uuidString
    public var title: String
    public var start: Date
    public var end: Date
    public var color: Color
    public var isAllDay: Bool

    ...
}
```
    


