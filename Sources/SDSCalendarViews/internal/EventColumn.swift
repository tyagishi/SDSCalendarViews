//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

public struct DictionaryWithDefault<Key: Hashable, Value> {
    var dictionary: [Key: Value]
    var defaultValue: Value

    public init(_ dic: [Key: Value] = [:], defaultValue: Value) {
        self.dictionary = dic
        self.defaultValue = defaultValue
    }
    subscript(key: Key) -> Value {
        get {
            dictionary[key, default: defaultValue]
        }
        set(newValue) {
            dictionary[key] = newValue
        }
    }
}

public struct  EventColumnFontDicKey: EnvironmentKey {
    public typealias Value = DictionaryWithDefault<Date, Font>
    static public var defaultValue: Value = DictionaryWithDefault<Date, Font>(defaultValue: .body)
}

extension EnvironmentValues {
    public var eventColumnFontDic: DictionaryWithDefault<Date, Font> {
        get {
            self[EventColumnFontDicKey.self]
        }
        set {
            self[EventColumnFontDicKey.self] = newValue
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
