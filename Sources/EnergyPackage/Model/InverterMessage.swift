//
//  File.swift
//  
//
//  Created by Dominik Liehr on 15.10.23.
//

import Foundation

public struct InverterMessage: Codable {
	var device: String
	var time: String
	var buffered: String
	var values: Values
}

public extension InverterMessage {
	struct Values: Codable {
		var datalogserial: String
		var pvserial: String
		var pvstatus: Int
		var pvpowerin: Int
		var pv1voltage: Int
		var pv1current: Int
		var pv1watt: Int
		var pv2voltage: Int
		var pv2current: Int
		var pv2watt: Int
		var pvpowerout: Int
		var pvfrequentie: Int
		var pvgridvoltage: Int
		var pvgridcurrent: Int
		var pvgridpower: Int
		var pvgridvoltage2: Int
		var pvgridcurrent2: Int
		var pvgridpower2: Int
		var pvgridvoltage3: Int
		var pvgridcurrent3: Int
		var pvgridpower3: Int
		var totworktime: Int
		var pvenergytoday: Int
		var pvenergytotal: Int
		var epvtotal: Int
		var epv1today: Int
		var epv1total: Int
		var epv2today: Int
		var epv2total: Int
		var pvtemperature: Int
		var pvipmtemperature: Int
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
