//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Decodable {
  let category: String
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]
    let type: String
    enum CodingKeys: String, CodingKey {
            case question
            case category
            case correctAnswer = "correct_answer"
            case incorrectAnswers = "incorrect_answers"
            case type
        }
}
