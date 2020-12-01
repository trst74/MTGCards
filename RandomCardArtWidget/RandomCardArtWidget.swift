//
//  RandomCardArtWidget.swift
//  RandomCardArtWidget
//
//  Created by Joseph Smith on 9/24/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    
    
    typealias Entry = SimpleEntry
    
    typealias Intent = CardArtConfigIntent

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(for configuration: CardArtConfigIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(for configuration: CardArtConfigIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for _ in 0 ..< 10 {
            if entries.count >= 6 {
                continue
            }
            var urlString = "https://api.scryfall.com/cards/random?q=-is%3AToken"
            if let type = configuration.type {
                urlString += "+t%3A\(type)"
            }
            if let commander = configuration.isCommander, commander == 1 {
                urlString += "+is%3Acommander+f%3Acommandervvv"
            }
            if let url = URL(string: urlString){
                let card = try? RandomCard(fromURL: url)
                
                guard let imageURL = URL(string: card?.imageUris.artCrop ?? "") else {
                    
                    continue
                }
                
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    print(imageURL)
                    if let data = data, error == nil  {
                        if let uiimage = UIImage(data: data), let card = card {
                            
                            let entryDate = Calendar.current.date(byAdding: .minute, value: entries.count * 10, to: currentDate)!
                            var entry = SimpleEntry(date: entryDate)
                            entry.card = card
                            entry.image = uiimage
                            entries.append(entry)
                        }
                    }
                    
                }.resume()
                
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var image: UIImage? = nil
    var card: RandomCard? = nil
}

struct RandomCardArtWidgetEntryView : View {
    var placeholder = Image(systemName: "photo")
    var entry: SimpleEntry
    let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    var body: some View {
        
        VStack(spacing: 0) {
            if let uiimage = entry.image {
                AnyView(Image(uiImage: uiimage).resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity,
                                   alignment: .center
                            )
                            .scaledToFill()
                )
            } else {
                AnyView(placeholder)
            }
            if let card = entry.card {
                Text(card.name)
                    
                    .foregroundColor(Color(UIColor.label))
                    .lineLimit(1)
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.01)
                    .padding(EdgeInsets(top: 4   , leading: 8, bottom: 4, trailing: 8))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .widgetURL(URL(string: "com.roboticsnailsoftware.MTGCollection:card?scryfallID=\(card.id)"))
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

@main
struct RandomCardArtWidget: Widget {
    let kind: String = "RandomCardArtWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CardArtConfigIntent.self, provider: Provider()) { entry in
            RandomCardArtWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemLarge])
        .configurationDisplayName("Random Card Art")
        .description("Art of a random MTG card. Click to open for card details.")
    }
}

struct RandomCardArtWidget_Previews: PreviewProvider {
    static var previews: some View {
        RandomCardArtWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
struct DebugBorder: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content.overlay(Rectangle().stroke(color))
    }
}

extension View {
    func debugBorder(color: Color = .blue) -> some View {
        #if DEBUG
        return self.overlay(Rectangle().stroke(color))
        #else
        return self
        #endif
    }
}
