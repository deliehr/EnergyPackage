//
//  InfluxManager.swift
//  
//
//  Created by Dominik Liehr on 15.10.23.
//

import Foundation
import MQTTNIO
import Combine
import SwiftUI
import InfluxDBSwift
import InfluxDBSwiftApis

@MainActor
public final class InfluxManager: ObservableObject {
	private var client: InfluxDBClient
	private var configuration: Configuration

	public init(with configuration: Configuration) {
		self.configuration = configuration

		let options = InfluxDBClient.InfluxDBOptions(bucket: configuration.bucket, org: configuration.orga, precision: .ns)

		client = InfluxDBClient(url: configuration.host, token: configuration.token, options: options)
	}
}

// MARK: - Public

extension InfluxManager {
	public func loadToday() async throws  -> [ChartValue] {
		return try await queryWatts()
	}
}

// MARK: - Private

private extension InfluxManager {
	var currentHour: Int {
		(Calendar.current.dateComponents([.hour], from: Date()).hour ?? 0) + 1
	}

	func queryWatts() async throws -> [ChartValue] {
		let rangeStart = "-\(currentHour)h"

		let query = """
			from(bucket: "\(configuration.bucket)")
			|> range(start: \(rangeStart))
			|> filter(fn: (r) => r["_measurement"] == "\(configuration.measurement)")
			|> filter(fn: (r) => r["_field"] == "pv1watt" or r["_field"] == "epv1today")
		"""

		let records = try await client.queryAPI.query(query: query)

		var chartValues = [ChartValue]()
		var maxChartValue: ChartValue!

		try records.forEach { record in
			guard let chartValue = ChartValue(withRecord: record) else { return }

			chartValues.append(chartValue)

			if maxChartValue == nil {
				maxChartValue = chartValue
			}

			if chartValue.rawValue > maxChartValue.rawValue {
				maxChartValue = chartValue
			}
		}

		var sortedAndReduced = chartValues.sorted { $0.date < $1.date }.filter { $0.rawValue > 0 }.reducedSize(toTargetCount: 100)

		for i in 0..<sortedAndReduced.count {
			sortedAndReduced[i].index = UInt(i)
		}

		if let maxChartValue, maxChartValue.rawValue > EnergyCommon.pv1wattMax {
			EnergyCommon.pv1wattMax = maxChartValue.rawValue
		}

		return sortedAndReduced
	}
}
