import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
    
}
struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personComponentPath = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion (nil) }
        let personURL = baseURL.appendingPathComponent(personComponentPath)
        let finalURL = personURL.appendingPathComponent(String(id))
        // 2 - Contact Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle Errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else { return completion(nil) }
            // 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
        
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        //        guard let url = URL(url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil) }
            // 4 - Check for data
            guard let data = data else {return completion(nil) }
            // 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Film.self, from: data)
                completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
}//end of class

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 3) { (person) in
    print(person?.name as Any)
    if let person = person {
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}
