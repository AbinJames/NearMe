//
//  TableViewController.swift
//  NearMe
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class TableViewController: UITableViewController {
	
	var places = [PlaceList]()
	var images = [Data?]()
	let webURL = "http://www.mocky.io/v2/5c4aa9a43400006b2c2695be"
	@IBOutlet weak var placesTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		//initialize table as empty to remove horizontal divisions
		self.placesTableView.tableFooterView = UIView()
		loadPlaces()
    }

    // Set number of columns in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

	//set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
	
	
	//Function to load place details from api
	func loadPlaces() {
		guard let url = URL(string: webURL) else {return}
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let dataResponse = data,
				error == nil else {
					print(error?.localizedDescription ?? "Response Error")
					return }
			//DispatchQueue used to load table data after data is retrieved from api
				DispatchQueue.main.async {
					let decoder = JSONDecoder()
					do {
						let apiResponse = try decoder.decode(PlaceModel.self, from: data!)
						
						//Set array of images that are loaded from image api in place data
						for place in apiResponse.results {
							self.places.append(place)
							self.loadImage(url: place.icon){
								(imageData) in
								self.images.append(imageData)
							}
						}
					}
					catch let parsingError {
						print("Error", parsingError)
					}
					//reload table view after data is retrieved
					self.placesTableView.reloadData()
				}
		}
		task.resume()
	}
	
	//Function to load image from api of place data
	func loadImage(url: String, completion: @escaping (Data?) -> Void){
		guard let imageURL = URL(string: url) else {return}
		let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
			guard let dataResponse = data,
				error == nil else {
					print(error?.localizedDescription ?? "Response Error")
					return }
			do{
				if( data != nil){
					completion(data!)
				}
				else{
					completion(nil)
				}
			} catch let parsingError {
				print("Error", parsingError)
			}
		}
		task.resume()
	}
	
	//Set cell data to be displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "PlaceTableViewCell"
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaceTableViewCell else {
				fatalError("The dequeued cell is not an instance of PlaceTableViewCell.")
		}
		
		//Configure the cell...
		let place = places[indexPath.row]
		if(images.count>0 && images[indexPath.row] != nil )
		{
			cell.placeImageView.image = UIImage(data: images[indexPath.row] as! Data)
		}
		else {
			cell.placeImageView.image = UIImage(named: "NearMeIcon")
		}
		cell.placeNameLabel.text = place.name
		cell.ratingLabel.text = "\(place.rating)/5.0"
		var priceRange = ""
		if (place.price_level != nil) {
			for _ in 0...(place.price_level as! Int) {
				priceRange += "₹"
			}
		}
		cell.priceRangeLabel.text = priceRange
        return cell
    }

	//On cell click functon
	//Perform call to segue on click
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "PlaceDetailsSegue", sender: places[indexPath.row])
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PlaceDetailsSegue" {
			let destinationVC = segue.destination as! ViewController
			destinationVC.place = sender as! PlaceList
		}
	}
	
}
