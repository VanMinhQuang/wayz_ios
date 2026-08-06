//
//  RealtimeMessagingClient.swift
//  wayz_ios
//

import Foundation

/// Thin wrapper around `WS /api/v1/ws/messages?token=...` (doc §9.4).
/// Connection stays open for inbound message events; the server pushes a
/// JSON-stringified `MessagePublic` whenever a new message is delivered to a
/// conversation the current user participates in.
final class RealtimeMessagingClient: NSObject {
    private let session: URLSession
    private var task: URLSessionWebSocketTask?

    override init() {
        session = URLSession(configuration: .default)
        super.init()
    }

    /// Opens the socket and starts listening. `onMessage` fires on every
    /// inbound `MessagePublic`; `onError` fires once and ends the stream.
    func connect(onMessage: @escaping (MessagePublicDTO) -> Void, onError: @escaping (Error) -> Void) {
        guard let token = KeychainService.shared.accessToken, let url = Self.webSocketURL(token: token) else {
            onError(NetworkError.unauthorized)
            return
        }
        let task = session.webSocketTask(with: url)
        self.task = task
        task.resume()
        listen(onMessage: onMessage, onError: onError)
    }

    func disconnect() {
        task?.cancel(with: .normalClosure, reason: nil)
        task = nil
    }

    private func listen(onMessage: @escaping (MessagePublicDTO) -> Void, onError: @escaping (Error) -> Void) {
        task?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                onError(error)
            case .success(let message):
                if let dto = Self.decode(message) {
                    onMessage(dto)
                }
                self.listen(onMessage: onMessage, onError: onError)
            }
        }
    }

    private static func decode(_ message: URLSessionWebSocketTask.Message) -> MessagePublicDTO? {
        let data: Data?
        switch message {
        case .string(let text): data = text.data(using: .utf8)
        case .data(let raw):    data = raw
        @unknown default:       data = nil
        }
        guard let data else { return nil }
        return try? JSONDecoder().decode(MessagePublicDTO.self, from: data)
    }

    /// Builds `ws(s)://<host>/api/v1/ws/messages?token=...` from the same base
    /// URL used for REST calls, honoring an explicit `SocketURL` override if configured.
    private static func webSocketURL(token: String) -> URL? {
        let base = AppConfig.current.socketURL ?? AppConfig.current.apiBaseURL
        guard var components = URLComponents(url: base, resolvingAgainstBaseURL: false) else { return nil }
        components.scheme = components.scheme == "https" ? "wss" : "ws"
        components.path = base.path.appending("/ws/messages")
        components.queryItems = [URLQueryItem(name: "token", value: token)]
        return components.url
    }
}
