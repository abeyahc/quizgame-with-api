//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  private var questions = [TriviaQuestion]()
    
  let triviaService = TriviaQuestionService()
    
    private func fixText(text: String) -> String {
            guard let newText = text.data(using: .utf8) else { return text }
            guard let attributedString = try? NSAttributedString(
                data: newText,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            ) else {
                return text
            }
            return attributedString.string
        }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    // TODO: FETCH TRIVIA QUESTIONS HERE
      triviaService.fetchTriviaQuestions { [weak self] (questions, error) in
              if let questions = questions {
                  self?.questions = questions
                  DispatchQueue.main.async {
                      self?.updateQuestion(withQuestionIndex: self?.currQuestionIndex ?? 0)
                  }
              } else if let error = error {
                  // Handle the error, e.g., show an alert to the user.
                  print("Error fetching trivia questions: \(error)")
              }
          }
  }
  
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
            currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
            let question = questions[questionIndex]
            let processedQuestionText = fixText(text: question.question)
            questionLabel.text = processedQuestionText
            categoryLabel.text = question.category

            let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()

            answerButton0.setTitle(fixText(text: answers[0]), for: .normal)
            answerButton1.setTitle(fixText(text: answers[1]), for: .normal)

            if question.type == "boolean" {
                answerButton2.isHidden = true
                answerButton3.isHidden = true
            } else {
                answerButton2.isHidden = false
                answerButton3.isHidden = false
                answerButton2.setTitle(fixText(text: answers[2]), for: .normal)
                answerButton3.setTitle(fixText(text: answers[3]), for: .normal)
            }
        }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
      let restartAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
              self.currQuestionIndex = 0
              self.numCorrectQuestions = 0
              self.triviaService.fetchTriviaQuestions { [weak self] (questions, error) in
                  if let questions = questions {
                      self?.questions = questions
                      DispatchQueue.main.async {
                          self?.updateQuestion(withQuestionIndex: self?.currQuestionIndex ?? 0)
                      }
                  } else if let error = error {
                      // Handle the error, e.g., show an alert to the user.
                      print("Error fetching trivia questions: \(error)")
                  }
              }
          }
      alertController.addAction(restartAction)
         present(alertController, animated: true, completion: nil)
     }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}


