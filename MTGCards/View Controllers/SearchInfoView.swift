//
//  SearchInfoView.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/8/21.
//

import SwiftUI

struct SearchInfoView: View {
    var body: some View {
        ScrollView {
            VStack{
                
                VStack {
                    Text("Type")
                        .font(.title)
                        .padding(.bottom, 6)
                    Text("Use t: or T:")
                        .lineLimit(0)
                    Text("This searches the cards subtype.")
                        .multilineTextAlignment(.center)
                    Text("For Example: Sliver, Elf, Goblin, Dragon")
                        .multilineTextAlignment(.center)
                    Text("t:Elf")
                        .multilineTextAlignment(.center)
                        
                        .frame(minWidth: 0, maxWidth: .infinity,  alignment: .center)
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(25.0)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(25.0)
                VStack {
                    Text("Color Identity")
                        .font(.title)
                        .padding(.bottom, 6)
                    Text("Use c: or C:")
                        .lineLimit(0)
                  
                    Text("For Example: W for white, U for blue, B for black, R for red, G for green.")
                        .multilineTextAlignment(.center)
                    Text("Colors can be used in combination and search for cards that are any combination of those colors.")
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                        .multilineTextAlignment(.center)
                    Text("c:UB")
                        .multilineTextAlignment(.center)
                    
                        .frame(minWidth: 0, maxWidth: .infinity,  alignment: .center)
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(25.0)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(25.0)
                VStack {
                    Text("Set")
                        .font(.title)
                        .padding(.bottom, 6)
                    Text("Use e: or E:")
                        .lineLimit(0)
                    Text("For Example: STH for Stronghold, WAR for War of the Spark")
                        .multilineTextAlignment(.center)
                    Text("Promotional cards for a set have a 'p' proceding the set symbol. i.e. pWAR for promotional War of the Spark")
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                    Text("e:STH")
                        .multilineTextAlignment(.center)
                    
                        .frame(minWidth: 0, maxWidth: .infinity,  alignment: .center)
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(25.0)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(25.0)
                VStack {
                    Text("Legality")
                        .font(.title)
                        .padding(.bottom, 6)
                    Text("Use f: or F:")
                        .lineLimit(0)
                    Text("Valid formats are: Brawl, Commander, Duel, Frontier, Legacy, Modern, Pauper, Penny, Standard, and Vintage.")
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                    Text("f:Modern")
                        .multilineTextAlignment(.center)
                    
                        .frame(minWidth: 0, maxWidth: .infinity,  alignment: .center)
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(25.0)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(25.0)
                VStack {
                    Text("Promotional")
                        .font(.title)
                        .padding(.bottom, 6)
                    Text("Use is:Promo")
                        .lineLimit(0)
                    Text("Limits search results to promotional printings.")
                        .multilineTextAlignment(.center)
                    Text("is:Promo")
                        .multilineTextAlignment(.center)
                    
                        .frame(minWidth: 0, maxWidth: .infinity,  alignment: .center)
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(25.0)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(25.0)
            }
            .padding()
        }
        .navigationTitle("Syntax")
    }
}

struct SearchInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchInfoView()
                .preferredColorScheme(.dark)
        }
    }
}
