//
//  Line_and_Pie_chartApp.swift
//  Line and Pie chart
//
//  Created by NikitaV on 03.02.2023.
//

import SwiftUI

@main
struct Line_and_Pie_chartApp: App {
    var body: some Scene {
        WindowGroup {
            ChartView(coin: DeveloperPreview.instance.coin, showChartDetail: true, frameChart: 200)
        }
    }
}
