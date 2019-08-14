import Foundation

struct Config: Decodable {
    
    let environment: String
    let clientID: String
    let clientSecret: String
    let appURLScheme: String
}
