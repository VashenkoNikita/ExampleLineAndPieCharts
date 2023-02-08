//
//  ContentView.swift
//  Line and Pie chart
//
//  Created by NikitaV on 03.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var totalPortfolioPrice: Double = 0
    
    let values: [Double]
    var colors: [Color]
    
    var widthFraction: CGFloat
    var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    init(values:[Double], colors: [Color] = [Color.blue, Color.green, Color.purple, Color.orange, Color.yellow, Color.blue, Color.red], widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.9){
        self.values = values
        
        self.colors = colors
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack{
                    ZStack{
                        ForEach(Array(slices.enumerated()), id:
                                    \.0){ index, slice in
                            PortfolioStatisticSlice(portfolioSliceData: slice)
                                .scaleEffect(self.activeIndex == index ? 1.03 : 1)
                                .animation(Animation.spring())
                        }
                                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                let radius = 0.5 * widthFraction * geometry.size.width
                                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                                    self.activeIndex = -1
                                                    return
                                                }
                                                var radians = Double(atan2(diff.x, diff.y))
                                                if (radians < 0) {
                                                    radians = 2 * Double.pi + radians
                                                }
                                                
                                                for (i, slice) in slices.enumerated() {
                                                    if (radians < slice.endAngle.radians) {
                                                        self.activeIndex = i
                                                        break
                                                    }
                                                }
                                            }
                                            .onEnded { value in
                                                self.activeIndex = -1
                                            }
                                    )
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: widthFraction * geometry.size.width * innerRadiusFraction , height: widthFraction * geometry.size.width * innerRadiusFraction )
                        
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(values: [1300, 500, 300, 600, 500])
    }
}

extension ContentView {
    private var slices: [PortfolioSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PortfolioSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PortfolioSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), color: colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
}
