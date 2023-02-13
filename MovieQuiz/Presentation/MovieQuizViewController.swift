import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alert: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    private enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    private enum ParseError: Error {
        case yearFailure
        case runtimeMinsFailure
    }

    // проверка состояния кнопок
    @IBOutlet private weak var noBtnState: UIButton!
    @IBOutlet private weak var yesBtnState: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAmswer = false
        showAnswerResult(isCorrect: givenAmswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAmswer = true
        showAnswerResult(isCorrect: givenAmswer == currentQuestion.correctAnswer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        alert = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}

extension MovieQuizViewController {
    // Конвертируем из массива во QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    // Функция отображения
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
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
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: self.correctAnswers, total: self.questionsAmount)
            
            guard let gameCount = statisticService?.gamesCount,
                  let bestGame = statisticService?.bestGame,
                  let totalAccuracy = statisticService?.totalAccuracy else {
                return
            }
            
            let messageAlert = """
              \(Constants.AlertLabel.scoreRound) \(correctAnswers)/\(questionsAmount) \n
              \(Constants.AlertLabel.numberOfQuizzesPlayed) \(gameCount) \n
              \(Constants.AlertLabel.bestScore) \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\n
              \(Constants.AlertLabel.avgAccuracy) \(totalAccuracy)%
              """
            
            let alertModel = AlertModel(
                title: Constants.AlertLabel.title,
                message: messageAlert,
                buttonText: Constants.AlertButton.buttonText,
                completion: {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
                })
            
            alert?.showAlert(result: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func resetScore() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
