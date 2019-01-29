//
//  ViewController.swift
//  NearMe
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var placeImageView: UIImageView!
	@IBOutlet weak var individualPlaceNameLabel: UILabel!
	@IBOutlet weak var individualPlaceVicinityLabel: UILabel!
	var semaphore = DispatchSemaphore(value: 0)
	var place : PlaceList?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getPlaceDetails()
		// Do any additional setup after loading the view, typically from a nib.
	}
	@IBAction func backButtonPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	func getPlaceDetails() {
		print(place!.name)
		individualPlaceNameLabel.text = place!.name
		individualPlaceVicinityLabel.text = place!.vicinity
		semaphore.signal()
		loadImage(url: place!.icon)
	}
	
	func loadImage(url: String){
		guard let imageURL = URL(string: url) else {return}
		let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
			guard let dataResponse = data,
				error == nil else {
					print(error?.localizedDescription ?? "Response Error")
					return }
			do{
				if( data != nil){
					DispatchQueue.main.async { // Make sure you're on the main thread here
						self.placeImageView.image = UIImage(data: data!)
					}
				}
				else{
					self.placeImageView.image = UIImage(named: "NearMeIcon")
				}
			} catch let parsingError {
				print("Error", parsingError)
			}
		}
		task.resume()
	}
}

