//
//  ViewController.swift
//  NearMe
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
	
	@IBOutlet weak var placeImageView: UIImageView!
	@IBOutlet weak var individualPlaceNameLabel: UILabel!
	@IBOutlet weak var individualPlaceVicinityLabel: UILabel!
	var place : PlaceList?
	@IBOutlet weak var imageScrollView: UIScrollView!
	var slides:[CustomView] = [];
	@IBOutlet weak var pageControl: UIPageControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageScrollView.delegate = self
		slides = createSlides()
		setupSlideScrollView(slides: slides)
		
		pageControl.numberOfPages = slides.count
		pageControl.currentPage = 0
		view.bringSubviewToFront(pageControl)
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
	
	func createSlides() -> [CustomView] {
		var allSlides = [CustomView]()
		for count in 0..<2{
			let slide:CustomView = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! CustomView
			slide.scrollImageView.image = UIImage(named: "sample_\(count+1)")
			allSlides += [slide]
		}
		return allSlides
	}
	
	func setupSlideScrollView(slides : [CustomView]) {
		imageScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
		imageScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: imageScrollView.frame.size.height)
		imageScrollView.contentSize.height = 1.0
		imageScrollView.isPagingEnabled = true
		
		for i in 0 ..< slides.count {
			slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
			imageScrollView.addSubview(slides[i])
		}
	}
	
	/*
	* default function called when view is scolled. In order to enable callback
	* when scrollview is scrolled, the below code needs to be called:
	* slideScrollView.delegate = self or
	*/
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
		pageControl.currentPage = Int(pageIndex)
		
		let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
		let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
		
		// vertical
		let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
		let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
		
		let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
		let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
		
		
		/*
		* below code changes the background color of view on paging the scrollview
		*/
		//        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
		
		
		/*
		* below code scales the imageview on paging the scrollview
		*/
		let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
		for index in 1..<slides.count{
			if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
			
				slides[index-1].scrollImageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
				slides[index].scrollImageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
			
			}
		}
	}

}

