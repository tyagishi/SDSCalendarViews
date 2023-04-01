//
//  EnvironmentVariables.swift
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
    public func calendarViewWidthDic(_ widthDic: DictionaryWithDefault<String, CGFloat>) -> some View {
        self.environment(\.calendarViewWidthDic, widthDic)
    }
    public func calendarViewHeightDic(_ heightDic: DictionaryWithDefault<String, CGFloat>) -> some View {
        self.environment(\.calendarViewHeightDic, heightDic)
    }
    public func calendarViewAlignmentDic(_ alignmentDic: DictionaryWithDefault<String, Alignment>) -> some View {
        self.environment(\.calendarViewAlignmentDic, alignmentDic)
    }

}

public struct CalendarViewFontDicKey: EnvironmentKey {
    public typealias Value = DictionaryWithDefault<String, Font>
    // key: "TimeColumn", "DayLabel", "NowLine", "2023/01/12"
    static public var defaultValue: Value = .init(defaultValue: .body)
}

public struct CalendarViewWidthDicKey: EnvironmentKey {
    // key might be "TimeColumn", "DateCell" or "2023/01/23"
    public typealias Value = DictionaryWithDefault<String, CGFloat>
    static public var defaultValue: Value = .init(defaultValue: 80)
}

public struct CalendarViewHeightDicKey: EnvironmentKey {
    // key might be "HourBlock"
    public typealias Value = DictionaryWithDefault<String, CGFloat>
    static public var defaultValue: Value = .init(defaultValue: 50)
}

public struct CalendarViewAlignmentDicKey: EnvironmentKey {
    public typealias Value = DictionaryWithDefault<String, Alignment>
    // key: "TimeColumn", "DayLabel"
    static public var defaultValue: Value = .init(defaultValue: .center)
}

extension EnvironmentValues {
    public var calendarViewFontDic: DictionaryWithDefault<String, Font> {
        get {
            self[CalendarViewFontDicKey.self]
        }
        set {
            self[CalendarViewFontDicKey.self] = newValue
        }
    }

    public var calendarViewWidthDic: DictionaryWithDefault<String, CGFloat> {
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
