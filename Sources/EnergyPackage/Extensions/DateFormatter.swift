//
//  File.swift
//  
//
//  Created by Dominik Liehr on 15.10.23.
//

import Foundation

extension DateFormatter {
	convenience init(format: String) {
		self.init()

		self.dateFormat = format
	}
}
