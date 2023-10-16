//
//  MqttManager.swift
//  
//
//  Created by Dominik Liehr on 13.10.23.
//

import Foundation
import MQTTNIO
import Combine

@MainActor
public final class MqttManager: ObservableObject {
	private var client: MQTTClient
	private var configuration: Configuration
	private var subscriptions = Set<AnyCancellable>()
	private var decoder = JSONDecoder()

	@Published public var isConnected = false
	@Published public var isSubscribed = false
	@Published public var inverterMessage: InverterMessage? = nil

	public init(with configuration: Configuration) {
		self.configuration = configuration

		var credentials: MQTTConfiguration.Credentials? = nil

		if let username = configuration.username, let password = configuration.password {
			credentials = .init(username: username, password: password)
		}

		let mqttConfiguration = MQTTConfiguration(target: .host(configuration.host, port: configuration.port), credentials: credentials)

		client = MQTTClient(configuration: mqttConfiguration, eventLoopGroupProvider: .createNew)

		client.connectPublisher
			.receive(on: DispatchQueue.main)
			.sink { _ in
				self.isConnected = true

				Task {
					try await self.subscribe()
				}
			}
			.store(in: &subscriptions)

		client.disconnectPublisher
			.receive(on: DispatchQueue.main)
			.sink { _ in
				self.isConnected = false
			}
			.store(in: &subscriptions)

		client.messagePublisher
			.receive(on: DispatchQueue.main)
			.sink { message in
				self.handle(message: message)
			}
			.store(in: &subscriptions)
	}
}

// MARK: - Public

public extension MqttManager {
	func connect() async throws {
		self.isConnected = false
		self.isSubscribed = false

		try await client.connect()
	}

	func connect() {
		Task {
			try await connect()
		}
	}

	func disconnect() async throws {
		try await unsubscribe()
		try await client.disconnect()
	}

	func disconnect() {
		Task {
			try await disconnect()
		}
	}
}

// MARK: - Private

private extension MqttManager {
	func subscribe() async throws {
		let result = (try await self.client.subscribe(to: configuration.topic)).result

		self.isSubscribed = {
			if case .success(_) = result {
				return true
			}
			return false
		}()
	}

	func unsubscribe() async throws {
		let result = (try await self.client.unsubscribe(from: configuration.topic)).result

		self.isSubscribed = result != .success
	}

	func handle(message: MQTTMessage) {
		guard let data = message.payload.string?.data(using: .utf8),
			  let inverterMessage = try? decoder.decode(InverterMessage.self, from: data) 
		else {
			self.inverterMessage = nil
			return
		}

		self.inverterMessage = inverterMessage

		if inverterMessage.values.pv1watt > Common.pv1wattMax {
			Common.pv1wattMax = Int64(inverterMessage.values.pv1watt)
		}
	}
}
