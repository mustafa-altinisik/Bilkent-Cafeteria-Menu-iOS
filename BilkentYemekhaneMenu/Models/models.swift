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
    let nutritionFacts: String

    private enum CodingKeys: String, CodingKey {
        case courses
        case englishName = "english_name"
        case id
        case name
        case nutritionFacts = "nutrition_facts"
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
