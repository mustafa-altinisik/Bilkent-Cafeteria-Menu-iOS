struct MenuResponse: Codable {
    let data: [String: Menu]
}

struct Menu: Codable {
    let alternative: Meal
    let lunch: Meal
    let dinner: Meal
}

struct Meal: Codable {
    let courses: [Course]
    let englishName: String
    let id: Int
    let name: String
    let nutritionFacts: [String: String] // modified to be a dictionary

    private enum CodingKeys: String, CodingKey {
        case courses
        case englishName = "english_name"
        case id
        case name
        case nutritionFacts = "nutrition_facts"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        courses = try values.decode([Course].self, forKey: .courses)
        englishName = try values.decode(String.self, forKey: .englishName)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        
        if let nutritionFactsDict = try? values.decode([String: String].self, forKey: .nutritionFacts) {
            nutritionFacts = nutritionFactsDict
        } else {
            nutritionFacts = [:] // default empty dictionary if key not found
        }
    }

}

struct Course: Codable {
    let englishName: String
    let id: Int
    let name: String

    private enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case id
        case name
    }
}

struct SingleNotification: Equatable {
    let name: String
    let hour: Int
    let minute: Int
    let days: [Int]
    let isOn: Bool
    
    static func == (lhs: SingleNotification, rhs: SingleNotification) -> Bool {
        return lhs.name == rhs.name &&
            lhs.hour == rhs.hour &&
            lhs.minute == rhs.minute &&
            lhs.days == rhs.days &&
            lhs.isOn == rhs.isOn
    }
}
