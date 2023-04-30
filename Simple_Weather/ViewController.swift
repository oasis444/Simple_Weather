//
//  ViewController.swift
//  Simple_Weather
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    let appID = "Input Your Api Key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getWeatherBtn(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true) // 키보드 내리기
        }
    }
    
    private func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(appID)") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInfo.self, from: data) else { return }
                DispatchQueue.main.async { // UI와 관련된 것들은 main 스레드에서 수행
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInfo: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
    
    private func configureView(weatherInfo: WeatherInfo) {
        self.cityNameLabel.text = weatherInfo.name
        if let weather = weatherInfo.weather.first {
            self.weatherDescription.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInfo.temp.temp - 273.15))℃"
        self.minTemp.text = "최저: \(Int(weatherInfo.temp.minTemp - 273.15))℃"
        self.maxTemp.text = "최고: \(Int(weatherInfo.temp.maxTemp - 273.15))℃"
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

