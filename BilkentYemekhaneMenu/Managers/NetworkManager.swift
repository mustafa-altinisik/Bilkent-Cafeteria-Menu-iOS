import Alamofire

// A networking class to manage fetching menu data
final class NetworkManager {
    
    // Singleton instance of NetworkManager
    static let shared = NetworkManager()
    
    // Private initializer to ensure only one instance is created
    private init() { }
    
    // Fetch menu data from the server and call the completion handler with the result
    func fetchMenu(completion: @escaping ([Menu]?, Error?) -> Void) {
        let url = "https://bilkent.gunlukhadis.com/getWeeklyMenu?apiKey=97a5a98437"
        // Send a request using Alamofire
        AF.request(url).responseJSON { response in
            if let error = response.error {
                // If there's an error, call the completion handler with the error
                completion(nil, error)
            } else if let data = response.data {
                do {
                    // Decode the JSON response using JSONDecoder
                    let decoder = JSONDecoder()
                    let menuResponse = try decoder.decode(MenuResponse.self, from: data)
                    let menus = Array(menuResponse.data.values)
                    // Sort the menus based on the order of days in a week
                    let sortedMenus = menus.sorted(by: { (menu1, menu2) -> Bool in
                        let dayOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                        let index1 = dayOrder.firstIndex(of: menu1.dinner.englishName)!
                        let index2 = dayOrder.firstIndex(of: menu2.dinner.englishName)!
                        return index1 < index2
                    })
                    // Call the completion handler with the sorted menu data
                    completion(sortedMenus, nil)
                } catch {
                    // If decoding fails, call the completion handler with the error
                    completion(nil, error)
                }
            } else {
                // If the response is invalid, create a custom error and call the completion handler
                let error = NSError(domain: "fetchMenu", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completion(nil, error)
            }
        }
    }
    
    func sendFavorite(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://bilkent.gunlukhadis.com/postFavorite"
        let parameters: [String: Any] = [
            "apiKey": "97a5a98437",
            "userId": UserDefaultsManager.shared.getUniqueId(),
            "favoriteMeals": UserDefaultsManager.shared.getAllLikedCourseIds()
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
