import WidgetKit
import SwiftUI

struct BilkentYemekhaneWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MyProvider()) { entry in
            MyWidgetView(entry: entry, courses: entry.courses, languageCode: entry.languageCode, currentTime: entry.currentTime)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MyProvider: TimelineProvider {
    func placeholder(in context: Context) -> MyEntry {
        MyEntry(date: Date(), courses: [], languageCode: "en", currentTime: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (MyEntry) -> ()) {
        let entry = MyEntry(date: Date(), courses: [], languageCode: "en", currentTime: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MyEntry>) -> ()) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: Date())
        let currentTime = Calendar.current.component(.hour, from: Date())
        guard let sharedDefaults = UserDefaults(suiteName: "group.altinisik.mustafa.BilkentYemekhaneMenu") else { return }
        let languageCode = sharedDefaults.string(forKey: "SelectedLanguage") ?? Locale(identifier: Locale.preferredLanguages.first ?? "en").languageCode ?? "en"

        guard var weekday = components.weekday else {
            return
        }
        weekday = weekday - 1

        if weekday == 0 {
            weekday = 7
        }

        MenuManager.shared.returnMenuFor(day: weekday) { meals in
            var courses: [Course] = []
            if let meals = meals {
                if currentTime < 14 {
                    courses = meals.lunch.courses
                } else {
                    courses = meals.dinner.courses
                }
            }

            var entries: [MyEntry] = []
            let currentDate = Date()
            for minuteOffset in stride(from: 0, to: 150, by: 15) {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                let entry = MyEntry(date: entryDate, courses: courses, languageCode: languageCode, currentTime: currentTime)
                entries.append(entry)
            }

            let nextRefreshDate: Date

            if currentTime < 14 {
                let nextRefreshComponents = DateComponents(hour: 14, minute: 0)
                nextRefreshDate = calendar.nextDate(after: currentDate, matching: nextRefreshComponents, matchingPolicy: .strict) ?? currentDate
            } else {
                nextRefreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
            }

            let entry = MyEntry(date: nextRefreshDate, courses: courses, languageCode: languageCode, currentTime: currentTime)
            entries.append(entry)

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct MyEntry: TimelineEntry {
    let date: Date
    let courses: [Course]
    let languageCode: String
    let currentTime: Int
}

struct MyWidgetView: View {
    var entry: MyProvider.Entry
    var courses: [Course]
    var languageCode: String
    var currentTime: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(headerText())
                .font(.system(size: 20))
            ForEach(courses, id: \.self) { course in
                HStack(alignment: .top, spacing: 4) {
                    Text("•")
                        .font(.system(size: 16))
                    if languageCode == "tr" {
                        Text(course.name)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 16))
                    } else {
                        Text(course.englishName)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 16))
                    }
                }
            }
        }
        .padding()
    }
    
    func headerText() -> String {
        if languageCode == "tr" {
            return currentTime < 14 ? "Öğle Menüsü" : "Akşam Menüsü"
        } else {
            return currentTime < 14 ? "Lunch Menu" : "Dinner Menu"
        }
    }
}


struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetView(entry: MyEntry(date: Date(), courses: [], languageCode: "en", currentTime: 0), courses: [], languageCode: "en", currentTime: 0)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

