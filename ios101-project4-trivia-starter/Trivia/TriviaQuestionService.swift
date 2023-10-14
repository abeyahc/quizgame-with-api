//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Abeyah Calpatura on 10/13/23.
//

import Foundation

struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

class TriviaQuestionService {
    // Define properties and methods for making API requests

    // You can add properties here, such as the base API URL, and an URLSession instance for making requests.

    init() {
        // Initialize any properties or configuration here.
    }

    // Implement a method to fetch trivia questions
    func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        if let url = URL(string: "https://opentdb.com/api.php?amount=5") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Network request error: (error)")
                    completion(nil, error)
                } else if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let triviaResponse = try decoder.decode(TriviaResponse.self, from: data)
                        completion(triviaResponse.results, nil)
                    } catch {
                        print("JSON decoding error: (error)")
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }


}
