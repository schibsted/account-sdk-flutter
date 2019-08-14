import Foundation
import SchibstedAccount

enum SchibstedAccountEventFactory {
    case loggedIn(user: User?, userProfile: UserProfile?)
    case loggedOut
    case canceled
    case error(error: Error)
    
    func getEvent() -> SchibstedAccountEvent {
        switch self {
        case .loggedIn(let user, let userProfile): return getLoggedInEvent(user, userProfile)
        case .loggedOut: return getLoggedOutEvent()
        case .canceled: return getCanceledEvent()
        case .error(let error): return getErrorEvent(error)
        }
    }
    
    private func getLoggedInEvent(_ user: User?, _ userProfile: UserProfile?) ->  SchibstedAccountEvent {
        guard let user = user,
        let userProfile = userProfile else {
            return SchibstedAccountEvent("logged_in")
        }
        
        let userData = UserData(
            displayName: userProfile.displayName ?? "",
            photo: "",
            email: userProfile.email?.originalString ?? "",
            id: user.id ?? "")
        
        return SchibstedAccountEvent("logged_in", schibstedAccountUserData: userData)
    }
    
    private func getLoggedOutEvent() ->  SchibstedAccountEvent {
        return SchibstedAccountEvent("logged_out")
    }
    
    private func getCanceledEvent() ->  SchibstedAccountEvent {
        return SchibstedAccountEvent("canceled")
    }
    
    private func getErrorEvent(_ error: Error) ->  SchibstedAccountEvent {
        
        if let error = error as? ClientError {
            let errorData = ErrorData(errorType: ClientError.domain,
                                      message: error.description)
            
            return SchibstedAccountEvent("error", schibstedAccountError: errorData)
        }
        
        let errorData = ErrorData(errorType: "unknownType",
                                  message: error.localizedDescription)
        
        return SchibstedAccountEvent("error", schibstedAccountError: errorData)
        
    }
}

