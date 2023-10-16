//
//  ChartValue.swift
//  
//
//  Created by Dominik Liehr on 15.10.23.
//

import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

public struct ChartValue: Identifiable {
	public var index: UInt
	public var id: UInt { index }
	public var date: Date
	public var rawValue: Int64
	public var value: Int64 { rawValue / 10 }
	public var xValue: Int = 0

	public init(date: Date, rawValue: Int64, index: UInt = 0) {
		self.date = date
		self.rawValue = rawValue
		self.index = index
	}

	public init?(withRecord record: QueryAPI.FluxRecord, index: UInt = 0) {
		guard let field = record.values["_field"] as? String,
			field == "pv1watt",
			let rawValue = record.values["_value"] as? Int64,
			let date = record.values["_time"] as? Date else { return nil }

		self.date = date
		self.rawValue = rawValue
		self.index = index
	}
}

extension Array where Element == ChartValue {
	var median: ChartValue {
		sorted(by: { $0.rawValue < $1.rawValue })[count / 2]
	}

	var max: ChartValue {
		self.max(by: { $0.rawValue < $1.rawValue })!
	}

	var avg: ChartValue {
		let sum: Int64 = self.reduce(0) { partialResult, chartValue in
			partialResult + chartValue.rawValue
		}

		let avgValue = sum / Int64(count)

		return self.min { cv0, cv1 in
			let diff0 = abs(cv0.rawValue - avgValue)
			let diff1 = abs(cv1.rawValue - avgValue)

			return diff0 < diff1
		}!
	}

	func reducedSize(toTargetCount targetCount: Int) -> [ChartValue] {
		guard targetCount >= 2, count >= targetCount else { return [] }

		var returnArray = [ChartValue]()

		let c = Double(count) / Double(targetCount)
		var index: Double = 0.0

		while index < Double(count) {
			let nextIndex = index + c

			guard nextIndex < Double(count) else { break }

			let from = Int(round(index))
			let to = Int(round(nextIndex))

			let median = Array(self[from..<to]).median

			returnArray.append(median)

			index = nextIndex
		}

		return returnArray
	}
}

