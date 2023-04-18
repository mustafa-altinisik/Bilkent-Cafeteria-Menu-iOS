import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager() // create a static instance variable
    
    private init() { } // make the initializer private
    
    func fetchMenu(completion: @escaping ([Menu]?, Error?) -> Void) {
        let url = "https://bilkent.gunlukhadis.com/getWeeklyMenu?apiKey=97a5a98437"
        AF.request(url).responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let menuResponse = try decoder.decode(MenuResponse.self, from: data)
                    let menus = Array(menuResponse.data.values)
                    let sortedMenus = menus.sorted(by: { (menu1, menu2) -> Bool in
                        let dayOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                        let index1 = dayOrder.firstIndex(of: menu1.dinner.englishName)!
                        let index2 = dayOrder.firstIndex(of: menu2.dinner.englishName)!
                        return index1 < index2
                    })
                    completion(sortedMenus, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                let error = NSError(domain: "fetchMenu", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completion(nil, error)
            }
        }
    }
}
