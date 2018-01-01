import Vapor

final class Station : NodeRepresentable, JSONRepresentable {
    
    var stationID : Int
    var name : String
    var lat : Double
    var lon : Double
    var available : Int
    var empty : Int
    
    
    init(stationID : Int, name : String, lat : Double, lon : Double, available : Int, empty : Int) {
        self.stationID = stationID
        self.name = name
        self.lat = lat
        self.lon = lon
        self.available = available
        self.empty = empty
    }
    
    func makeNode(in context: Context?) throws -> Node {
        return try Node(node: ["id" : stationID, "a" : available, "e" : empty])
    }
        
    func makeJSON() throws -> JSON {
        var json = JSON()
        
        
        try json.set("id", stationID)
        try json.set("a", available)
        try json.set("e", empty)
        
        /*
        try json.set("stationID", stationID)
        try json.set("name", name)
        try json.set("lat", lat)
        try json.set("lon", lon)
        try json.set("available", available)
        try json.set("empty", empty)
        */
        return json
    }

    
}
