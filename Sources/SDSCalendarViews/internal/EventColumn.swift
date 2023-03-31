//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

public struct  EventColumnFontDicKey: EnvironmentKey {
    public typealias Value = [Date: Font]
    static public var defaultValue: Value = [:]
}

public struct  EventColumnDefaultFontKey: EnvironmentKey {
    public typealias Value = Font
    static public var defaultValue: Value = .body
}

extension EnvironmentValues {
    public var eventColumnFontDic: [Date: Font] {
        get {
            self[EventColumnFontDicKey.self]
        }
        set {
            self[EventColumnFontDicKey.self] = newValue
        }
    }
    public var eventColumnDefaultFont: Font {
        get {
            self[EventColumnDefaultFontKey.self]
        }
        set {
            self[EventColumnDefaultFontKey.self] = newValue
        }
    }
}

struct EventColumn: View {
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
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
        EventColumn(viewModel: CalendarViewModel.emptyExample(Date()), date: Date(), hourHeight: 80)
    }
}
