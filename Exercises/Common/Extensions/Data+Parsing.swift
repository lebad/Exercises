//
//  Data+Parsing.swift
//  Exercises
//
//  Created by Andrey Lebedev on 21.01.2024.
//

import Foundation

extension Data {
	var prettyString: String {
		if let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any],
		   JSONSerialization.isValidJSONObject(dict),
		   let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
		   let bodyString = String(data: data, encoding: .utf8) {
			return bodyString
		} else if let bodyString = NSString(data: self, encoding: String.Encoding.utf8.rawValue) {
			return bodyString as String
		} else {
			return "Can't render body"
		}
	}
}
