import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0

    // проверка состояния кнопок
    @IBOutlet private weak var noBtnState: UIButton!
    @IBOutlet private weak var yesBtnState: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAmswer = false
        showAnswerResult(isCorrect: givenAmswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAmswer = true
        showAnswerResult(isCorrect: givenAmswer == currentQuestion.correctAnswer)
    }

    // Конвертируем из массива во QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    // Функция отображения
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {[weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    // Функция проверки корректности ответа
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        self.noBtnState.isEnabled = false
        self.yesBtnState.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.noBtnState.isEnabled = true
            self.yesBtnState.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count-1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
    
            show(quiz: viewModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        let currentQuestion = questions[currentQuestionIndex]
        let currentStep = convert(model: currentQuestion)
        show(quiz: currentStep)
    }
    
    // для состояния "Вопрос задан"
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }

    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
}
