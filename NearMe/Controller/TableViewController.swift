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
		self.placesTableView.tableFooterView = UIView()
		loadPlaces()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
	
	func loadPlaces() {
		guard let url = URL(string: webURL) else {return}
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let dataResponse = data,
				error == nil else {
					print(error?.localizedDescription ?? "Response Error")
					return }
				DispatchQueue.main.async {
					let decoder = JSONDecoder()
					//var imageSemaphore = DispatchSemaphore(value: 0)
					do {
						let apiResponse = try decoder.decode(PlaceModel.self, from: data!)
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
					self.placesTableView.reloadData()
				}
		}
		task.resume()
	}
	
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

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "PlaceDetailsSegue", sender: places[indexPath.row])
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PlaceDetailsSegue" {
			let destinationVC = segue.destination as! ViewController
			destinationVC.place = sender as! PlaceList
		}
	}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
