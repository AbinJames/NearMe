//
//  PlaceModel.swift
//  NearMe
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

struct PlaceList : Codable {
	var name: String
	var price_level: Int?
	var rating: Double
	var vicinity: String
	var icon: String
	var geometry: Geometry
}

struct Geometry: Codable{
	var location: Location
}

struct Location: Codable {
	var lat: Double
	var lng: Double
}

class PlaceModel : Codable {
	var html_attributions: [String]
	var results: [PlaceList]
}
