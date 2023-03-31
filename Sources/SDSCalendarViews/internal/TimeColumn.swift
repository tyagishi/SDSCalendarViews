//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/03
//  © 2023  SmallDeskSoftware
//

import SwiftUI

public struct TimeColumnFontKey: EnvironmentKey {
    public typealias Value = Font
    static public var defaultValue: Font = .body
}

extension EnvironmentValues {
    public var timeColumnFont: Font {
        get {
            self[TimeColumnFontKey.self]
        }
        set {
            self[TimeColumnFontKey.self] = newValue
        }
    }
}

struct TimeColumn: View {
    @Environment(\.timeColumnFont) var font
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
    let labelWidth: CGFloat
    let hourHeight: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.hourRanges(date), id: \.self) { hour in
                Text(CalendarViewModel.formattedTime(hour.lowerBound)).minimumScaleFactor(0.1)
                    .monospacedDigit()
                    .font(font)
                    .padding(.leading, 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .frame(width: labelWidth, height: hourHeight)
            }
        }
    }
}

struct TimeColumn_Previews: PreviewProvider {
    static var previews: some View {
        TimeColumn(viewModel: CalendarViewModel.exampleForWeekView(), date: Date(), labelWidth: 300, hourHeight: 80)
    }
}
