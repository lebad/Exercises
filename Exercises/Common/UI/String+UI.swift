//
//  String+UI.swift
//  Exercises
//
//  Created by Andrey Lebedev on 25.01.2024.
//

import Foundation
import UIKit

extension String {
	var decodedHtmlAttrbutedString: NSAttributedString? {
		guard let data = data(using: .utf8) else {
			return nil
		}
		return try? NSAttributedString(
			data: data,
			options: [.documentType: NSAttributedString.DocumentType.html],
			documentAttributes: nil
		)
	}
}
