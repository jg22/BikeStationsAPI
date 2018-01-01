@_exported import Vapor

extension Droplet {
    
    
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
        
        
        let stationController = StationController()
        //stationController.generateStations()
        stationController.getStations(drop: self)
        stationController.addRoutes(drop: self)
        
        self.resource("posts", PostController())

    }
}
