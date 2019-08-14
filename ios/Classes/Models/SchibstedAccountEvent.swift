import Foundation

struct SchibstedAccountEvent: Codable {
    let schibstedAccountLoginState: String
    let schibstedAccountUserData: UserData?
    let schibstedAccountError: ErrorData?
    
    init(_ schibstedAccountLoginState: String,
         schibstedAccountUserData: UserData? = nil,
         schibstedAccountError: ErrorData? = nil) {
        self.schibstedAccountLoginState = schibstedAccountLoginState
        self.schibstedAccountUserData = schibstedAccountUserData
        self.schibstedAccountError = schibstedAccountError
    }
    
    func getJSONString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

struct UserData: Codable {
    let displayName: String
    let photo: String
    let email: String
    let id: String
}

struct ErrorData: Codable {
    let errorType: String
    let message: String
}
