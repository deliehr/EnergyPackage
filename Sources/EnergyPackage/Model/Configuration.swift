//
//  File.swift
//  
//
//  Created by Dominik Liehr on 15.10.23.
//

import Foundation

public extension MqttManager {
	struct Configuration {
		var host: String
		var port: Int
		var username: String?
		var password: String?
		var topic: String

		public init(host: String, port: Int = 1_883, username: String? = nil, password: String? = nil, topic: String) {
			self.host = host
			self.port = port
			self.username = username
			self.password = password
			self.topic = topic
		}
	}
}
