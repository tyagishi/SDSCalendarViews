//
//  EnvironmentValues.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/01
//  © 2023  SmallDeskSoftware
//

import Foundation
import SDSSwiftExtension
import SwiftUI

// MARK: font/size/alignment control
extension View {
    public func calendarViewFontDic(_ fontDic: DictionaryWithDefault<String, Font>) -> some View {
        self.environment(\.calendarViewFontDic, fontDic)
    }
    public func calendarViewWidthDic(_ widthDic: [String: CGFloat]) -> some View {
        self.environment(\.calendarViewWidthDic, widthDic)
    }
    public func calendarViewHeightDic(_ heightDic: DictionaryWithDefault<String, CGFloat>) -> some View {
        self.environment(\.calendarViewHeightDic, heightDic)
    }
    public func calendarViewAlignmentDic(_ alignmentDic: DictionaryWithDefault<String, Alignment>) -> some View {
        self.environment(\.calendarViewAlignmentDic, alignmentDic)
    }
    public func calendarViewFormatStyleDic(_ formatStyleDic: [CalendarFormatStyleKey: Date.FormatStyle]) -> some View {
        self.environment(\.calendarViewFormatStyleDic, formatStyleDic)
    }
}

public enum CalendarFormatStyleKey: String, RawRepresentable {
    case leadDayLabel = "LeadDayLabel"
    case restDaysLabel = "RestDaysLabel"
    case todayLabel = "TodayLLabel"
    case timeLabel = "TimeLabel"
}

public enum CalendarDicKey: String, RawRepresentable {
    case timeColumn = "TimeColumn" // for width, font, alignment
    case dayLabel = "DayLabel"     // for height, font, alignment
    case nowLine = "NowLine"       // for font
    case hourBlock = "HourBlock"   // for height
    case dayEvent = "DayEvent"     // for font, height, alignment
}

public struct CalendarViewFormatStyleDicKey: EnvironmentKey {
    public typealias Value = [CalendarFormatStyleKey: Date.FormatStyle]
    // key: "TimeColumn", "DayLabel", "NowLine", "2023/01/12", "DayEvent"
    static public var defaultValue: Value = [:]
}

public struct CalendarViewFontDicKey: EnvironmentKey {
    public typealias Value = DictionaryWithDefault<String, Font>
    // key: "TimeColumn", "DayLabel", "NowLine", "2023/01/12", "DayEvent"
    static public var defaultValue: Value = .init(defaultValue: .body)
}

public struct CalendarViewWidthDicKey: EnvironmentKey {
    // key might be "TimeColumn" or "2023/01/23"
    public typealias Value = [String: CGFloat]
    static public var defaultValue: Value = [:]
}

public struct CalendarViewHeightDicKey: EnvironmentKey {
    // key might be "HourBlock", "DayEvent"
    public typealias Value = DictionaryWithDefault<String, CGFloat>
    static public var defaultValue: Value = .init(defaultValue: 50)
}

public struct CalendarViewAlignmentDicKey: EnvironmentKey {
    public typealias Value = DictionaryWithDefault<String, Alignment>
    // key: "TimeColumn", "DayLabel"
    static public var defaultValue: Value = .init(defaultValue: .center)
}

extension EnvironmentValues {
    public var calendarViewFormatStyleDic: [CalendarFormatStyleKey: Date.FormatStyle] {
        get {
            self[CalendarViewFormatStyleDicKey.self]
        }
        set {
            self[CalendarViewFormatStyleDicKey.self] = newValue
        }
    }

    public var calendarViewFontDic: DictionaryWithDefault<String, Font> {
        get {
            self[CalendarViewFontDicKey.self]
        }
        set {
            self[CalendarViewFontDicKey.self] = newValue
        }
    }

    public var calendarViewWidthDic: [String: CGFloat] {
        get {
            self[CalendarViewWidthDicKey.self]
        }
        set {
            self[CalendarViewWidthDicKey.self] = newValue
        }
    }

    public var calendarViewHeightDic: DictionaryWithDefault<String, CGFloat> {
        get {
            self[CalendarViewHeightDicKey.self]
        }
        set {
            self[CalendarViewHeightDicKey.self] = newValue
        }
    }
    public var calendarViewAlignmentDic: DictionaryWithDefault<String, Alignment> {
        get {
            self[CalendarViewAlignmentDicKey.self]
        }
        set {
            self[CalendarViewAlignmentDicKey.self] = newValue
        }
    }
}
