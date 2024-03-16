import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var weatherLabel : UILabel!
    @IBOutlet var weatherButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherButton.addTarget(self, action: #selector(weatherButtonTapped), for: .touchUpInside)
    }
    
    @objc func weatherButtonTapped() {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let reqest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: reqest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Request error: ", error)
                return
            }
                        
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weatherLabel.text = "\(weather.currentWeather.temperature) °C"
                }
            } catch {
                print("Decoding error: ", error)
            }
        }
        task.resume()
    }
}
