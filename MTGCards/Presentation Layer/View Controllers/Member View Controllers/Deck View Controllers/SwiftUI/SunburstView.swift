//
//  SunburstView.swift
//  SunburstDiagram
//
//  Created by Ludovic Landry on 6/10/19.
//  Copyright © 2019 Ludovic Landry. All rights reserved.
//

import SwiftUI

public struct SunburstView: View {
    
    @ObservedObject var sunburst: Sunburst
    
    public init(configuration: SunburstConfiguration) {
        sunburst = configuration.sunburst
    }
    
    public var body: some View {
        var view = AnyView(Text("There is no data to display."))
        if sunburst.configuration.nodes.count > 0 {
            
            
            let arcs = ZStack {
                configureViews(arcs: sunburst.rootArcs)
                
                // Stop the window shrinking to zero when there is no arcs.
                Spacer()
            }
            .flipsForRightToLeftLayoutDirection(true)
            .padding()
            
            view = AnyView(arcs.drawingGroup())
            
        }
        return view
        
        
    }
    
    private func configureViews(arcs: [Sunburst.Arc], parentArc: Sunburst.Arc? = nil) -> some View {
        return ForEach(arcs) { arc in
            ArcView(arc: arc, configuration: self.sunburst.configuration)
        }
    }
}

#if DEBUG
struct SunburstView_Previews : PreviewProvider {
    static var previews: some View {
        let configuration = SunburstConfiguration(nodes: [
            Node(name: "6", value: 6.0, backgroundColor: UIColor(named: "Plains") ),
            Node(name: "4", value: 4.0, backgroundColor: UIColor(named: "Islands")),
            Node(name: "5", value: 5.0, backgroundColor: UIColor(named: "Swamps")),
            Node(name: "10", value: 10000.0, backgroundColor: UIColor(named: "Mountains")),
            Node(name: "1", value: 1.0, backgroundColor: UIColor(named: "Forests") )
        ], calculationMode: .ordinalFromLeaves)
        return SunburstView(configuration: configuration)
    }
}
#endif
