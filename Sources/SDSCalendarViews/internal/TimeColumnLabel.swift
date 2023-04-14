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

    public init() { }
    public var body: some View {
        Color.clear
            .frame(width: widthDic[.timeColumn], height: heightDic[.dayLabel])
    }
}

public struct TimeColumnEventLabel: View {
    @Environment(\.calendarViewWidthDic) var widthDic
    @Environment(\.calendarViewHeightDic) var heightDic

    public init() { }
    public var body: some View {
        Color.clear
            .frame(width: widthDic[.timeColumn], height: heightDic[.dayEvent])
    }
}
