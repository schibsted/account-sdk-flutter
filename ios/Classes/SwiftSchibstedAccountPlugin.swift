import Flutter
import UIKit
import SchibstedAccount

enum Methods: String {
    case login
    case logout
}

enum FlutterChannels: String {
    case callbacks = "schibsted_account/callbacks"
    case events = "schibsted_account/events"
}

public class SwiftSchibstedAccountPlugin: NSObject, FlutterPlugin {
    
    var identityUI: IdentityUI?
    var loginEventSink: FlutterEventSink?
    var user: User?
    var clientConfiguration: ClientConfiguration?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: FlutterChannels.callbacks.rawValue,
                                           binaryMessenger: registrar.messenger())
        let instance = SwiftSchibstedAccountPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        
        let eventChannel = FlutterEventChannel(name: FlutterChannels.events.rawValue,
                                               binaryMessenger: registrar.messenger(),
                                               codec: FlutterJSONMethodCodec.sharedInstance())
        eventChannel.setStreamHandler(instance)

        instance.loadSchibstedAccountConfig()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch Methods(rawValue: call.method) {
        case .login?: login()
        case .logout?: logout()
        default: result(nil)
        }
    }

    private func loadSchibstedAccountConfig() {
        guard let url = Bundle.main.url(forResource: "SchibstedAccountConfig", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let config = try? PropertyListDecoder().decode(Config.self, from: data)
            else { return }
        
        clientConfiguration = ClientConfiguration(
            environment: ClientConfiguration.Environment(rawValue: config.environment) ?? .development,
            clientID: config.clientID,
            clientSecret: config.clientSecret,
            appURLScheme: config.appURLScheme
        )
    }

    private func loadLastLoggedUser() {
        guard let clientConfiguration = clientConfiguration else { return }

        let user = User.loadLast(withConfiguration: clientConfiguration);
        switch user.state {
        case .loggedIn:
            onUserLoggedIn(user: user)
        default: break
        }
    }
    
    private func login() {
        guard let clientConfiguration = clientConfiguration else { return }
        
        let config = IdentityUIConfiguration(clientConfiguration: clientConfiguration)
        identityUI = IdentityUI(configuration: config)
        identityUI?.delegate = self
        guard let viewCtrl = UIApplication.shared.delegate?.window??.rootViewController else {
            return
        }
        
        identityUI?.presentIdentityProcess(from: viewCtrl, route: .login)
    }
    
    private func logout() {
        user?.logout()
        sendEvent(SchibstedAccountEventFactory.loggedOut)
    }
    
    private func onUserLoggedIn(user: SchibstedAccount.User) {
        self.user = user
        
        sendEvent(SchibstedAccountEventFactory.loggedIn(user: nil, userProfile: nil))
        user.profile.fetch { [weak self] result in
            switch result {
            case let .success(userProfile):
                self?.sendEvent(SchibstedAccountEventFactory.loggedIn(user: user, userProfile: userProfile))
            case let .failure(error):
                self?.sendEvent(SchibstedAccountEventFactory.error(error: error))
            }
        }
    }
    
    private func onCanceled() {
        sendEvent(SchibstedAccountEventFactory.canceled)
    }
    
    private func onFailed(error: Error) {
        sendEvent(SchibstedAccountEventFactory.error(error: error))
    }
    
    private func sendEvent(_ factory: SchibstedAccountEventFactory) {
        loginEventSink?(factory.getEvent().getJSONString())
    }
}

extension SwiftSchibstedAccountPlugin: FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        loginEventSink = events
        loadLastLoggedUser()
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        loginEventSink = nil
        return nil
    }
}

extension SwiftSchibstedAccountPlugin: IdentityUIDelegate {
    
    public func didFinish(result: IdentityUIResult) {
        switch result {
        case let .completed(user): onUserLoggedIn(user: user)
        case .canceled: onCanceled()
        case .skipped: onCanceled()
        case let .failed(error): onFailed(error: error)
        }
    }
}

