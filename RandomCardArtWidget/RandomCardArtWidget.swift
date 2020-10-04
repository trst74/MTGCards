//
//  RandomCardArtWidget.swift
//  RandomCardArtWidget
//
//  Created by Joseph Smith on 9/24/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot( in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline( in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for _ in 0 ..< 10 {
            if entries.count >= 6 {
                continue
            }
            if let url = URL(string: "https://api.scryfall.com/cards/random"){
                let card = try? RandomCard(fromURL: url)
                
                guard let imageURL = URL(string: card?.imageUris.artCrop ?? "") else {
                    fatalError("ImageURL is not correct!")
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

            ZStack{
                if let uiimage = entry.image {
                    AnyView(Image(uiImage: uiimage).resizable().aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity,
                                       minHeight: 0,
                                       maxHeight: .infinity,
                                       alignment: .topLeading
                                )
                            //.scaledToFill()
                    )
                } else {
                    AnyView(placeholder)
                }
                if let card = entry.card {
                    
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
                    .widgetURL(URL(string: "com.roboticsnailsoftware.MTGCollection:card?scryfallID=\(card.id)"))
                }
                
            }

    }
}

@main
struct RandomCardArtWidget: Widget {
    let kind: String = "RandomCardArtWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RandomCardArtWidgetEntryView(entry: entry)
        }
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
