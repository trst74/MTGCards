//
//  CardArtWidget.swift
//  CardArtWidget
//
//  Created by Joseph Smith on 9/17/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CardArtWidgetEntryView : View {
    @ObservedObject private var widgetLoader = WidgetLoader()
    var placeholder = Image(systemName: "photo")
    init() {
        widgetLoader.load()
    }
    
    var body: some View {
        
        ZStack{
            if let uiImage = self.widgetLoader.downloadedImage {
                AnyView(Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fill)  .frame(minWidth: 0,
                                                                                                    maxWidth: .infinity,
                                                                                                    minHeight: 0,
                                                                                                    maxHeight: .infinity,
                                                                                                    alignment: .topLeading
                ))
            } else {
                AnyView(placeholder)
            }
            if let card = self.widgetLoader.card {
           
                    GeometryReader{g in
                        VStack{
                            Spacer()
                                .frame(minWidth: 0,
                                              maxWidth: .infinity,
                                              minHeight: 0,
                                              maxHeight: .infinity,
                                              alignment: .bottom
                            )
                        Text(card.name)
                            
                            .foregroundColor(Color(UIColor.label))
                            .lineLimit(1)
                            .font(.system(size: 20))
                            .minimumScaleFactor(0.01)
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                         
                            .frame(minWidth: 0,
                                   maxWidth: .infinity
                            )
                            .background(Color(UIColor.systemBackground))
                            
                 
                        }
                }
            }
            
        }
    }
    
}



@main
struct CardArtWidget: Widget {
    let kind: String = "CardArtWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CardArtWidgetEntryView()
        }
        .configurationDisplayName("Card Art")
        .description("This is an example widget.")
    }
}



