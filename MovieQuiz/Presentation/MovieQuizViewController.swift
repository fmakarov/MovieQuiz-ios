import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    private var presenter: MovieQuizPresenter!
    private var alert: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    private enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    private enum ParseError: Error {
        case yearFailure
        case runtimeMinsFailure
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }

    // проверка состояния кнопок
    @IBOutlet private weak var noBtnState: UIButton!
    @IBOutlet private weak var yesBtnState: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        alert = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
            
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
}

extension MovieQuizViewController {
    // Функция отображения
    func show(quiz result: QuizResultsViewModel) {
        if let statisticService = statisticService {
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        }
        
        guard let gameCount = statisticService?.gamesCount,
              let bestGame = statisticService?.bestGame,
              let totalAccuracy = statisticService?.totalAccuracy else {
            return
        }
        
        let messageAlert = """
          \(Constants.AlertLabel.scoreRound) \(presenter.correctAnswers)/\(presenter.questionsAmount) \n
          \(Constants.AlertLabel.numberOfQuizzesPlayed) \(gameCount) \n
          \(Constants.AlertLabel.bestScore) \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\n
          \(Constants.AlertLabel.avgAccuracy) \(totalAccuracy)%
          """
        
        let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)"
        let action = AlertModel(title: Constants.AlertLabel.title, message: messageAlert, buttonText: Constants.AlertButton.buttonText) {
            self.presenter.restartGame()
        }
        
        alert?.showAlert(result: action)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // Функция проверки корректности ответа
    func showAnswerResult(isCorrect: Bool){
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        self.noBtnState.isEnabled = false
        self.yesBtnState.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки не скрыт
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        presenter.correctAnswers = 0
        
        let action = AlertModel(title: "Попробовать ещё раз", message: message, buttonText: Constants.AlertButton.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alert?.showAlert(result: action)
    }
}
