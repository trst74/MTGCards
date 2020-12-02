//
//  CMCTableView.swift
//  MTGCards
//
//  Created by Joseph Smith on 2/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct BarChart: View {
    let bars: [Bar]
    
    var body: some View {
        Group {
            if bars.isEmpty {
                Text("There is no data to display.")
            } else {
               
                    BarsView(bars: bars)
                    
                
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
                //.padding(.bottom, 50)
            }
        }
    }
}

struct Bar: Identifiable {
    let id: UUID
    let value: Double
    let label: String
    let color: Color
}

struct BarsView: View {
    let bars: [Bar]
    let max: Double
    
    init(bars: [Bar]) {
        self.bars = bars
        self.max = bars.map { $0.value }.max() ?? 0
    }
    
    var body: some View {
        //GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(self.bars) { bar in
                    VStack {
                        Text("\(Int(bar.value))")
                            .font(.subheadline)
                        Rectangle()
                            .fill(bar.color)
                            .frame( height: CGFloat(bar.value) / CGFloat(self.max) * 150)
                            .accessibility(label: Text(bar.label))
                            
                            .padding(.all, 5)
                        
                        Text(bar.label)
                            .font(.subheadline)
                        
                    }
                    .padding(.bottom, 10)
                }
            }
//        }
    }
}

struct LabelsView: View {
    let bars: [Bar]
    let labelsCount: Int
    
    private var threshold: Int {
        let threshold = bars.count / labelsCount
        return threshold == 0 ? 1 : threshold
    }
    
    var body: some View {
        HStack {
            ForEach(0..<bars.count, id: \.self) { index in
                Group {
                    if index % self.threshold == 0 {
                        Spacer()
                        Text(self.bars[index].label)
                            .font(.caption)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
        }
    }
}
struct CMCTableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BarChart(bars:
                [Bar(id: UUID(), value: 2.2, label: "Plains", color: Color("Plains")),
                 Bar(id: UUID(), value: 8.2, label: "Islands",color: Color("Islands")),
                 Bar(id: UUID(), value: 4.2, label: "Swamps",color: Color("Swamps")),
                 Bar(id: UUID(), value: 6.0, label: "Mountains",color: Color("Mountains")),
                 Bar(id: UUID(), value: 4.2, label: "Forests",color: Color("Forests"))])
                .environment(\.colorScheme, .dark)
           
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 mini"))
            BarChart(bars:
                [Bar(id: UUID(), value: 2.2, label: "Plains", color: Color("Plains")),
                 Bar(id: UUID(), value: 8.2, label: "Islands",color: Color("Islands")),
                 Bar(id: UUID(), value: 4.2, label: "Swamps",color: Color("Swamps")),
                 Bar(id: UUID(), value: 6.0, label: "Mountains",color: Color("Mountains")),
                 Bar(id: UUID(), value: 4.2, label: "Forests",color: Color("Forests"))])
                .environment(\.colorScheme, .light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
        }
    }
}
