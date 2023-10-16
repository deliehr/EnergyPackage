//
//  InverterMessage.swift
//  
//
//  Created by Dominik Liehr on 15.10.23.
//

import Foundation

public struct InverterMessage: Codable {
	public var device: String
	public var time: String
	public var buffered: String
	public var values: Values
}

public extension InverterMessage {
	struct Values: Codable {
		public var datalogserial: String
		public var pvserial: String
		public var pvstatus: Int
		public var pvpowerin: Int
		public var pv1voltage: Int
		public var pv1current: Int
		public var pv1watt: Int
		public var pv2voltage: Int
		public var pv2current: Int
		public var pv2watt: Int
		public var pvpowerout: Int
		public var pvfrequentie: Int
		public var pvgridvoltage: Int
		public var pvgridcurrent: Int
		public var pvgridpower: Int
		public var pvgridvoltage2: Int
		public var pvgridcurrent2: Int
		public var pvgridpower2: Int
		public var pvgridvoltage3: Int
		public var pvgridcurrent3: Int
		public var pvgridpower3: Int
		public var totworktime: Int
		public var pvenergytoday: Int
		public var pvenergytotal: Int
		public var epvtotal: Int
		public var epv1today: Int
		public var epv1total: Int
		public var epv2today: Int
		public var epv2total: Int
		public var pvtemperature: Int
		public var pvipmtemperature: Int
	}
}

// MARK: - Convenience

public extension InverterMessage {
	var timestamp: Date? {
		DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss").date(from: time)
	}

	var shortTimeString: String? {
		let formatter = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss")

		guard let date = formatter.date(from: time) else { return nil }

		return DateFormatter(format: "HH:mm").string(from: date)
	}
}
