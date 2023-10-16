//
//  Configuration.swift
//  
//
//  Created by Dominik Liehr on 15.10.23.
//

import Foundation

public extension MqttManager {
	struct Configuration {
		var host: String
		var port: Int = 1_883
		var username: String?
		var password: String?
		var topic: String

		public init(host: String, port: Int, username: String? = nil, password: String? = nil, topic: String) {
			self.host = host
			self.port = port
			self.username = username
			self.password = password
			self.topic = topic
		}
	}
}

public extension InfluxManager {
	struct Configuration {
		var host: String
		var username: String
		var password: String
		var token: String
		var orga: String
		var bucket: String
		var measurement: String

		public init(host: String, username: String, password: String, token: String, orga: String, bucket: String, measurement: String) {
			self.host = host
			self.username = username
			self.password = password
			self.token = token
			self.orga = orga
			self.bucket = bucket
			self.measurement = measurement
		}
	}
}
