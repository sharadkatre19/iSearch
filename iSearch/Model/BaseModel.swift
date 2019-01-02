//
//  ViewController.swift
//  iSearch
//
//  Created by Sharad Katre on 31/12/18.
//  Copyright © 2018 Sharad Katre. All rights reserved.
//

import Foundation

struct BaseModel : Codable {
	let total_count : Int?
	let incomplete_results : Bool?
	let items : [Items]?

	enum CodingKeys: String, CodingKey {

		case total_count = "total_count"
		case incomplete_results = "incomplete_results"
		case items = "items"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
		incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
		items = try values.decodeIfPresent([Items].self, forKey: .items)
	}

}
