//
//  ConfigurationWidget.swift
//  ConfigurationWidget
//
//  Created by Fadey Notchenko on 06.02.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationWidgetIntent(), isPreview: true)
    }

    func getSnapshot(for configuration: ConfigurationWidgetIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, isPreview: true)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationWidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, isPreview: false)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationWidgetIntent
    let isPreview: Bool
}

struct ConfigurationWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    private var target: TargetWidgetEntity? {
        guard let ud = UserDefaults(suiteName: Constants.appGroup) else { return nil }
        
        guard let data = ud.object(forKey: entry.configuration.parameter?.identifier ?? "") as? Data else { return nil }
        
        guard let targetWidget = targetWidgetFromData(data: data) else { return nil }
        
        return targetWidget
    }
    
    private var percent: CGFloat {
        if let target = target {
            return min(CGFloat(target.current * 100 / target.price), 100.0)
        }
        
        //for placeholder
        return 75
    }

    var body: some View {
        if entry.isPreview {
            //preview
            let previewTarget = TargetWidgetEntity(id: UUID().uuidString, name: "My Target", price: 1000, current: 750, color: UIColor.systemPink.encode(), currency: Currency.usd.rawValue)
            
            WidgetView(previewTarget)
        } else if let target = target {
            WidgetView(target)
        } else {
            //hint
        }
    }
    
    private func WidgetView(_ target: TargetWidgetEntity) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(target.name)
                .bold()
                .font(.title3)
                .lineLimit(1)
            
            WidgetCapsuleProgress(width: widgetFamily == .systemSmall ? 90 : 200, color: target.color)
            
            Text("\(target.current) / \(target.price) \(target.currency)")
                .bold()
                .font(widgetFamily == .systemSmall ? .system(size: 16) : .system(size: 19))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
    
    private func WidgetCapsuleProgress(width: CGFloat, color: Data) -> some View {
        ZStack(alignment: .leading) {
            
            ZStack(alignment: .trailing) {
                HStack {
                    Capsule()
                        .fill(.gray.opacity(0.2))
                        .frame(width: width, height: 12)
                    
                    Text("(\(Int(percent)) %)")
                        .bold()
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            
            Capsule()
                .fill(Color(UIColor.color(withData: color)))
                .frame(width: percent / 100 * width, height: 12)
        }
    }
}

struct ConfigurationWidget: Widget {
    let kind: String = "ConfigurationWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationWidgetIntent.self, provider: Provider()) { entry in
            ConfigurationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ConfigurationWidget_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationWidgetIntent(), isPreview: true))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
