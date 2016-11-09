//
//  ViewController.swift
//  MorningBreath
//
//  Created by Karen Fuentes, Thinley Dorjee, Victor Zhong on 11/7/16.
//  Copyright © 2016 Karen Fuentes, Thinley Dorjee, Victor Zhong. All rights reserved.
//


import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    
    var news = [News]()
    var weather: Weather?
    var images = [Image]()
    var user = "Karin"
    var quote: Quote?
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
        loadNews()
        loadImages()
        
        loadQuote()
        
        
        
        loadQuote()
        
    }
    
    
    // MARK: - Load Data code
    let synthesizer = AVSpeechSynthesizer()
    
    @IBAction func voiceButtonTapped(_ sender: UIButton) {
        guard let weather = weather else { return }
        let myUtterance = AVSpeechUtterance(string: "Good morning, \(user). You can look forward to \(weather.description) with a high of \(weather.maxTemp) degrees and a low of \(weather.minTemp) today. In other news today: \(news[0].title). \(news[0].description)")
        myUtterance.rate = 0.6
        myUtterance.pitchMultiplier = 1.3
        //		if isPaused {
        
        synthesizer.pauseSpeaking(at: .word)
        synthesizer.speak(myUtterance)
    }
    
    func loadImages() {
        let endPoint = "http://www.splashbase.co/api/v1/images/latest"
        APIRequestManager.manager.getData(endPoint: endPoint) { (data) in
            if data != nil{
                print("step 1")
                if let images = Image.ArrOfImage(from: data!){
                    self.images = images
                    DispatchQueue.main.async {
                        APIRequestManager.manager.getData(endPoint: self.images[0].image) { (data: Data?) in
                            if  let validData = data,
                                let validImage = UIImage(data: validData) {
                                DispatchQueue.main.async {
                                    self.backgroundImage.image = validImage
                                    self.backgroundImage.alpha = 0.60
                                    self.backgroundImage.setNeedsLayout()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadWeather() {
        let weatherEndpoint = "http://api.openweathermap.org/data/2.5/weather?q=new%20york%20+%20%22,us&appid=3ee9654253b3b473a0036b4bf2179181"
        APIRequestManager.manager.getData(endPoint: weatherEndpoint) { (data:Data?) in
            if data != nil {
                if let weatherInfo = Weather.getWeather(from: data!) {
                    print("we got weather info")
                    self.weather = weatherInfo
                    DispatchQueue.main.async {
                        self.locationLabel.text = weatherInfo.location
                        self.descLabel.text = weatherInfo.description.capitalized
                        self.maxLabel.text = "\(weatherInfo.maxTemp)°"
                        self.minLabel.text = "\(weatherInfo.minTemp)°"
                        self.tempLabel.text = "\(weatherInfo.temperature)°"
                    }
                }
            }
        }
    }
    
    func loadNews(from outlet: String = "the-washington-post", apiKey: String = "72856ca4721f4116be898282fbff3a95") {
        let newsEndpoint = "https://newsapi.org/v1/articles?source=\(outlet)&sortBy=top&apiKey=\(apiKey)"
        
        //let escapedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        APIRequestManager.manager.getData(endPoint: newsEndpoint) { (data: Data?) in
            if  let validData = data,
                let validNews = News.getNews(from: validData) {
                self.news = validNews
                dump(self.news)
                //				DispatchQueue.main.async {
                //					self.tableView?.reloadData()
                //				}
            }
        }
    }
    
    
    
    func loadQuote() {
        let QuoteEndpoint = "http://quotes.rest/qod.json?category=life"
        APIRequestManager.manager.getData(endPoint: QuoteEndpoint) { (data:Data?) in
            if data != nil {
                if let quoteInfo = Quote.getDailyLifeQuote(from: data!) {
                    print("we got quote info")
                    self.quote = quoteInfo
                    DispatchQueue.main.async {
                        //self.quoteLabel.text = quoteInfo.quote
                        //self.quoteAuthorLabel.text = quoteInfo.author
                    }
                }
            }
        }
    }
    
    
    func makingDate() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM dd, yyyy"
        return dateformatter.string(from: Date())
        
    }

	
	var news = [News]()
	var weather: Weather?
	var images = [Image]()
	var user = "Karinceeta"
	var quote: Quote?
	var isPaused = true
	
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var tintedView: UIImageView!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var maxLabel: UILabel!
	@IBOutlet weak var minLabel: UILabel!
	@IBOutlet weak var backgroundImage: UIImageView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tintedView.layer.cornerRadius = 8.0
		loadWeather()
		loadNews()
		loadImages()
		loadQuote()
	}
	
	// MARK: - Load Data code
	let synthesizer = AVSpeechSynthesizer()
	
	@IBAction func voiceButtonTapped(_ sender: UIButton) {
		guard let weather = weather else { return }
		guard let quote = quote else { return }
		let myUtterance = AVSpeechUtterance(string: "Good morning. You can look forward to \(weather.description) with a high of \(weather.maxTemp) degrees and a low of \(weather.minTemp) today. \(quote.author) once said: \(quote.quote). Today's top headline: \(news[0].title). \(news[0].description)")
		myUtterance.rate = 0.5
		myUtterance.pitchMultiplier = 1.3
		
		if isPaused {
			synthesizer.speak(myUtterance)
			isPaused = false
		}
		else {
			synthesizer.pauseSpeaking(at: .immediate)
			isPaused = true
		}
		
	}
	
		func loadImages() {
			let endPoint = "http://www.splashbase.co/api/v1/images/latest"
			APIRequestManager.manager.getData(endPoint: endPoint) { (data) in
				if data != nil{
					print("step 1")
					if let images = Image.ArrOfImage(from: data!){
						self.images = images
						DispatchQueue.main.async {
							APIRequestManager.manager.getData(endPoint: self.images[0].image) { (data: Data?) in
								if  let validData = data,
									let validImage = UIImage(data: validData) {
									DispatchQueue.main.async {
										self.backgroundImage.image = validImage
										self.backgroundImage.alpha = 1
										self.backgroundImage.setNeedsLayout()
									}
								}
							}
						}
					}
				}
			}
		}
		
		func loadWeather() {
			let weatherEndpoint = "http://api.openweathermap.org/data/2.5/weather?q=new%20york%20+%20%22,us&appid=3ee9654253b3b473a0036b4bf2179181"
			APIRequestManager.manager.getData(endPoint: weatherEndpoint) { (data:Data?) in
				if data != nil {
					if let weatherInfo = Weather.getWeather(from: data!) {
						print("we got weather info")
						self.weather = weatherInfo
						DispatchQueue.main.async {
							self.locationLabel.text = weatherInfo.location
							self.descLabel.text = weatherInfo.description.capitalized
							self.maxLabel.text = "\(weatherInfo.maxTemp)°"
							self.minLabel.text = "\(weatherInfo.minTemp)°"
							self.tempLabel.text = "\(weatherInfo.temperature)°"
						}
					}
				}
			}
		}
		
		func loadNews(from outlet: String = "the-washington-post", apiKey: String = "72856ca4721f4116be898282fbff3a95") {
			let newsEndpoint = "https://newsapi.org/v1/articles?source=\(outlet)&sortBy=top&apiKey=\(apiKey)"
			
			//let escapedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
			APIRequestManager.manager.getData(endPoint: newsEndpoint) { (data: Data?) in
				if  let validData = data,
					let validNews = News.getNews(from: validData) {
					self.news = validNews
					dump(self.news)
					//				DispatchQueue.main.async {
					//					self.tableView?.reloadData()
					//				}
				}
			}
		}
		
		
		
		func loadQuote() {
			let QuoteEndpoint = "http://quotes.rest/qod.json?category=life"
			APIRequestManager.manager.getData(endPoint: QuoteEndpoint) { (data:Data?) in
				if data != nil {
					if let quoteInfo = Quote.getDailyLifeQuote(from: data!) {
						print("we got quote info")
						self.quote = quoteInfo
						DispatchQueue.main.async {
							//self.quoteLabel.text = quoteInfo.quote
							//self.quoteAuthorLabel.text = quoteInfo.author
						}
					}
				}
			}
     }
}

