import Vapor
import Console

final class UpdateStation: Command {
    public let id = "upd"
    public let help = ["This command does things, like foo, and bar."]
    public let console: ConsoleProtocol
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        console.print("Update station...")
    }
}
