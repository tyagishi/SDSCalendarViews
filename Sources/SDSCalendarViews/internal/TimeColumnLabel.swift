//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/02
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

public struct TimeColumnLabel: View {
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic

    let tcKey = CalendarDicKey.timeColumn.rawValue
    let dlKey = CalendarDicKey.dayLabel.rawValue
    let deKey = CalendarDicKey.dayEvent.rawValue

    public init() { }
    public var body: some View {
        Color.clear
            .frame(width: widthDic[tcKey], height: heightDic[dlKey])
    }
}

public struct TimeColumnEventLabel: View {
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic

    let tcKey = CalendarDicKey.timeColumn.rawValue
    let dlKey = CalendarDicKey.dayLabel.rawValue
    let deKey = CalendarDicKey.dayEvent.rawValue

    public init() { }
    public var body: some View {
        Color.clear
            .frame(width: widthDic[tcKey], height: heightDic[deKey])
    }
}
