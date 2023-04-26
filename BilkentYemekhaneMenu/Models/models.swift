// Represents the entire menu response structure from the API
struct MenuResponse: Codable {
    // A dictionary where the key is a date string and the value is a Menu object
    let data: [String: Menu]
}

// Represents a daily menu containing alternative, lunch, and dinner meals
struct Menu: Codable {
    let alternative: Meal
    let lunch: Meal
    let dinner: Meal
}

// Represents a meal with courses, name, ID, English name, and nutrition facts
struct Meal: Codable {
    let courses: [Course]
    let englishName: String
    let id: Int
    let name: String
    let nutritionFacts: [String: String] // nutrition facts stored as a dictionary

    // Define custom coding keys for decoding JSON keys to Swift properties
    private enum CodingKeys: String, CodingKey {
        case courses
        case englishName = "english_name"
        case id
        case name
        case nutritionFacts = "nutrition_facts"
    }
    
    // Custom initializer to handle optional nutritionFacts key during decoding
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        courses = try values.decode([Course].self, forKey: .courses)
        englishName = try values.decode(String.self, forKey: .englishName)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        
        // If the nutritionFacts key is not found, use an empty dictionary as a default value
        if let nutritionFactsDict = try? values.decode([String: String].self, forKey: .nutritionFacts) {
            nutritionFacts = nutritionFactsDict
        } else {
            nutritionFacts = [:] // default empty dictionary if key not found
        }
    }
}

// Represents a course within a meal with name, ID, and English name
struct Course: Codable, Hashable{
    let englishName: String
    let id: Int
    let name: String

    // Define custom coding keys for decoding JSON keys to Swift properties
    private enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case id
        case name
    }
}

// Represents a single notification for a meal with time, days, and on/off status
struct SingleNotification: Equatable {
    let name: String
    let hour: Int
    let minute: Int
    let days: [Int] // array of integers, where 1 represents a selected day and 0 represents a deselected day
    let isOn: Bool // true if the notification is enabled, false otherwise
    
    // Equatable conformance to compare two SingleNotification objects for equality
    static func == (lhs: SingleNotification, rhs: SingleNotification) -> Bool {
        return lhs.name == rhs.name &&
            lhs.hour == rhs.hour &&
            lhs.minute == rhs.minute &&
            lhs.days == rhs.days &&
            lhs.isOn == rhs.isOn
    }
}
