//
//  RulingsView.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/9/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct RulingsView: View {
    var rulings: [Ruling]
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    var body: some View {
        VStack{
            ForEach(rulings, id: \.self ) { ruling in
                VStack{
                    Text(ruling.text ?? "")
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
                    Text("\((ruling.date!).toDate() ?? Date(), formatter: Self.taskDateFormat)").font(.system(size: 10.0, weight: .thin))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
                }
                .padding(.init(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
            
        }
    }
}

