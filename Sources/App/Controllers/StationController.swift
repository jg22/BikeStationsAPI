import Vapor
import HTTP
import PerfectXML
//import PerfectNet
//import PerfectNotifications

struct StaStruct {
    var StationID : Int
    var StationName : String
}


final class StationController {
    
    var stations = [Station]()
    var drop : Droplet?

    /*
    func generateStations() {
        for i in 0..<10 {
            stations += try Station(name: "Station \(i)", available: 10 + i, empty: 7 + i)
        }
    }
    */
    
    func addRoutes(drop : Droplet) {
        let stations = drop.grouped("stations")
        stations.get("all", handler: allStations)
        //stations.get("push", handler: pushNotification)
        stations.get("update", handler: updateStations)
        
        self.drop = drop
    }
    
    func allStations(request: Request) throws -> JSON {
        //let station = try Station(name: "new", available: 10, empty: 7)
        //return try station.makeJSON()
        return try stations.makeJSON()
    }
    
    func updateStations(request: Request) throws -> JSON {
        if let d = self.drop {
            self.getStations(drop: d, updateOnly: true)
        }
        return try JSON(node: ["message" : "Station updated"])

    }

    
    
    func getStations(drop : Droplet, updateOnly : Bool = false) {
        
        do {
            let bikesResponse = try drop.client.get("http://www.c-bike.com.tw/xml/stationlistopendata.aspx")
            
            if let bodyBytes = bikesResponse.body.bytes {
            
                if let string = String(bytes: bodyBytes, encoding: String.Encoding.utf8) {
                    
                    
                    
                    let document = XDocument(fromSource: string)
                    let rootElement = document?.documentElement
                    
                    
                    if let stations = rootElement?.getElementsByTagName("Station") {
                        
                        for station in stations {
                            
                            guard
                                let staID = station.getElementsByTagName("StationID").first?.nodeValue,
                                let name = station.getElementsByTagName("StationName").first?.nodeValue,
                                let lat = station.getElementsByTagName("StationLat").first?.nodeValue,
                                let lon = station.getElementsByTagName("StationLon").first?.nodeValue,
                                let available = station.getElementsByTagName("StationNums1").first?.nodeValue,
                                let empty = station.getElementsByTagName("StationNums2").first?.nodeValue else {
                                continue
                            }

                            
                            if updateOnly {
                                
                                for s in self.stations {
                                    if s.stationID == Int(staID)! {
                                        
                                        if s.available != Int(available)! {
                                            print("Station \(name) available from \(s.available) -> \(available)")
                                            s.available = Int(available)!
                                        }
                                        
                                        if s.empty != Int(empty)! {
                                            print("Station \(name) empty from \(s.empty) -> \(empty)")
                                            s.empty = Int(empty)!
                                        }
                                        
                                    }
                                }
                                
                            }
                            else {
                                let newStation = Station(stationID: Int(staID)!, name: name, lat: Double(lat)!, lon: Double(lon)!, available: Int(available)!, empty: Int(empty)!)
                                
                                self.stations.append(newStation)
                            }
                            
                        }
                        
                        
                        
                    }
                    
                }
            
            }
            
            
        }
        catch {
            print("error in getting bikes")
        }
        
        
    }
    
    /*
    func pushNotification(request: Request) throws -> ResponseRepresentable {
        // BEGIN one-time initialization code
        
        let configurationName = "My configuration name - can be whatever"
        
        NotificationPusher.addConfigurationIOS(name: configurationName) {
            (net:NetTCPSSL) in
            
            // This code will be called whenever a new connection to the APNS service is required.
            // Configure the SSL related settings.
            
            //net.keyFilePassword = "if you have password protected key file"
            
            
            /*
            guard net.useCertificateFile("path/to/aps_development.pem") &&
                net.usePrivateKeyFile("path/to/key.pem") &&
                net.checkPrivateKey() else {
                    
                    let code = Int32(net.errorCode())
                    print("Error validating private key file: \(net.errorStr(code))")
                    return
            }
            */
            guard net.useCertificateFile(cert: "Resources/APNs/pem/cretificate.pem") &&
                net.usePrivateKeyFile(cert: "Resources/APNs/pem/privateKey.pem") &&
                net.checkPrivateKey() else {
                    
                    let code = Int32(net.errorCode())
                    print("Error validating private key file: \(net.errorStr(forCode: code))")
                    return
            }
            
        }
        
        NotificationPusher.development = true // set to toggle to the APNS sandbox server
        
        // END one-time initialization code
        
        // BEGIN - individual notification push
        
        let deviceId = "BCB8BC658D7A3361AD02EA753C8421D9D237838D002C6C5E0A0BC492F9348D82"
        let ary = [IOSNotificationItem.alertBody("Hi there!"), IOSNotificationItem.sound("default")]
        let n = NotificationPusher()
        
        
        n.apnsTopic = "com.LesCadeaux.BikeInformation"
        
        
        
        n.pushIOS(configurationName: configurationName, deviceToken: deviceId, expiration: 0, priority: 10, notificationItems: ary) {
            response in
            
            print("NotificationResponse: \(response.status) \(response.body)")
        }
        
        // END - individual notification push
        
        return "Push sent"
    }
    */
    
}
