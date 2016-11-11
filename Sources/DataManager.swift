//
//  DataManager.swift
//
//Copyright (c) 2015-2016 Tensai Solutions LLC.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Vapor
import HTTP
import Foundation

class DataManager {
    // Singleton instance manages fetching and supporting data repository for the bot
    static let instance = DataManager()
    
    var truckURL:String = ""
    var locationURL:String = ""
    
    let drop = Droplet()
    var truckList = [Truck]()
    var locationList = Set<Location>()
    var nearMeLocations = [TruckLocations]()
    var nearMeToken = ""
    

//MARK: - Process & Format Functions
    func handleMessage(message:String) -> String {
        var returnMessage = ""
        //if let incomingMessage = replaceMatches(pattern: "[<].*[>]", inString: message, withString: "") {
            
            let slackMessage:SlackMessage = processMessage(message: message)
        
            switch slackMessage.messageType {
            case .Trucks:
            //Get All Trucks
                returnMessage = formatTruckMessage(forTrucks: truckList)
                break
            case .Locations:
            //Get All Locations
                returnMessage = formatLocationMessage(forLocations: locationList.array)
                break
            case .Special:
            //Get Trucks Near Cengage
                returnMessage = getTrucks(byDays: [DayOfWeek.today()], forLocations: nearMeLocations)
                break
            case .Help:
            //Return Commands Available
                returnMessage = createHelpMessage()
                break
            case .TruckNames:
            //Locations of a Truck(s) For Today
                returnMessage = getTrucksFor(truckNames: slackMessage.truckNames!, days: [DayOfWeek.today()])
                break
            case .TruckNamesAndDay:
            //Locations of Truck(s) for a Day
                returnMessage = getTrucksFor(truckNames: slackMessage.truckNames!, days: slackMessage.daysOfWeek!)
                break
            case .TrucksByLocation:
            //Get all Trucks For Location(s)
                returnMessage = getTrucks(byDays: [DayOfWeek.today()], forLocations: slackMessage.Locations!)
                break
            case .TrucksByLocationAndDay:
            //Get all Trucks For Locations(s) For Day(s)
                returnMessage = getTrucks(byDays: slackMessage.daysOfWeek!, forLocations: slackMessage.Locations!)
                break
            case .Error:
            //Return Error Message
                returnMessage = "I'm not sure I understood you. Try using *'Help'* to see what I can do."
                break
            }
        //}
        
        return returnMessage
    }
    
    //TruckNames For all Locations 
    //For each TruckName we need to get the "routeName" then we need to find it in the Locations Set Where Day = Day
    private func getTrucksFor(truckNames:[Truck], days:[DayOfWeek]) -> String {
        var formattedString = ""
        
        for truck in truckNames {
            formattedString += formatTruckMessage(forTrucks: [truck], boldTruck: true)
            for day in days {
                formattedString += "*For \(day.rawValue)*\n"
                for location in locationList {
                    if location.days.contains(where: {$0.dayOfWeek == day}) {
                        let locationDay = location.days[(location.days.index(where: {$0.dayOfWeek == day}))!]
                        for item in locationDay.trucks {
                            //check to see if we have a match (if so then add to the message)
                            if item == truck.routeName {
                                if let truckLocation = location.location {
                                    formattedString += truckLocation + "\n"
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return formattedString
    }
    
    private func getTrucks(byDays:[DayOfWeek], forLocations:[TruckLocations]) -> String {
        
        var formattedString = ""
        //For Each Day Get the Trucks for the Location
        for day in byDays {
            //Check All the Locations in the List
            for location in forLocations {
                let currentLocation = locationList[(locationList.index(where: {$0.locationId == location}))!]
                formattedString += "*\(currentLocation.location!) For \(day.rawValue)* \n"
                print(formattedString)
                //Check to see if the Day is present in the location
                let filteredTruckList = getRequestedTrucks(forDay: day, andLocation: currentLocation.locationId)
                formattedString += formatTruckMessage(forTrucks: filteredTruckList)
            }
        }
        
        return formattedString
    }
    
    private func getRequestedTrucks(forDay:DayOfWeek, andLocation:TruckLocations) -> [Truck] {
        var trucks = [Truck]()
        //Given a Location and Day of the Week. Return an array of Truck Objects
        if locationList.contains(where: {$0.locationId == andLocation}) {
            let currentLocation = locationList[(locationList.index(where: {$0.locationId == andLocation}))!]
            //Do we have trucks for this day of the week?
            if currentLocation.days.contains(where: {$0.dayOfWeek == forDay}) {
                let day = currentLocation.days[currentLocation.days.index(where: {$0.dayOfWeek == forDay})!]
                
                for truck in day.trucks {
                    if truckList.contains(where: {$0.routeName == truck.string}) {
                        
                        let newTruck = truckList[truckList.index(where: {$0.routeName == truck.string})!]
                            trucks.append(newTruck)
                    }
                }
            }
        }
        return trucks
    }
    
    private func formatTruckMessage(forTrucks:[Truck], boldTruck:Bool = false) -> String {
        var formattedString = ""
        
        for truck in forTrucks {
            if let truckName = truck.name, let truckfood = truck.foodTypeEmoji, let yelpRating = truck.yelpRatingEmoji, let twitter = truck.twitter {
                if boldTruck {
                    formattedString += "\(truckfood) *\(truckName)* \(yelpRating) \(twitter)\n"
                }else {
                    formattedString += "\(truckfood) \(truckName) \(yelpRating) \(twitter)\n"
                }
            }
        }
        
        return formattedString
    }
    
    func loadTrucksNearMe(data:[Polymorphic]){
        for location in data {
            if checkLocation(location: location.string!) {
                nearMeLocations.append(TruckLocations(rawValue: location.string!)!)
            }
            
        }
    }
    
    
    
    private func trucksNearCengage() -> [TruckLocations] {
        
        return [TruckLocations.InnovationDistrict,TruckLocations.SeaportWormwood,TruckLocations.Dewey,TruckLocations.GreenwayDeweyCongress,TruckLocations.GreenwayRowesWharf]
    }
    
    private func createHelpMessage() -> String {
        
        let formattedString = "*Here are the Commands I Understand:*\n" +
            ">>>`Help` -> You are here know\n" +
            "`Trucks` -> List all the Food Trucks I know about\n" +
            "`Locations` -> List all the Locations for Food Trucks\n" +
            "`\(nearMeToken)` -> List all the Food Trucks near \(nearMeToken) for Today\n" +
            "`Trucks at Location(s)` -> Lists the trucks for Today at the given Locations\n" +
            ">_Example:_ Trucks at watertown-athena, brighamwomen\n" +
            "`Trucks at Location(s) for Days` -> Lists trucks for the given day(s) at the given Locations\n" +
            ">_Example:_ Trucks at greenway-dewey-congress, financial-milk-kilby for Monday, Tuesday\n" +
            "`Truck Name(s)` -> Retrieve the requested Truck(s) Locations for Today\n" +
            ">_Example:_ Blazing Salads, Bon Me\n" +
            "`Truck Name(s) for Days` -> Retrieve the requested Truck(s) Locations for the given Day(s)\n" +
        ">_Example:_ Blazing Salads, Bon Me for Monday,Tuesday"
        
        
        return formattedString
    }
    
    private func formatLocationMessage(forLocations:[Location]) -> String {
        var formattedString = ""
        
        for location in forLocations {
            formattedString += "`\(location.locationId)` \(location.message!)\n"
        }
        
        return formattedString
    }

    
//MARK: - Helper Functions
    private func checkLocation(location:String) -> Bool {
        
        return (TruckLocations(rawValue: location) != nil)
    }
    
    private func filterLocations(locations:[String]) -> [TruckLocations] {
        var returnString = [TruckLocations]()
        for location in locations {
            if checkLocation(location: location) {
                returnString.append(TruckLocations(rawValue: location)!)
            }
        }
        
        return returnString
        
    }
    
    private func filterTrucks(truckNames:[String]) -> [Truck] {
        var returnValue = [Truck]()
        
        for truck in truckNames {
            let trimmedTruck = truck.trimmingCharacters(in: .whitespacesAndNewlines)
            if truckList.contains(where: {$0.name == trimmedTruck}) {
                returnValue.append(truckList[truckList.index(where: {$0.name == trimmedTruck})!])
            }
        }
        
        return returnValue
    }

    //MARK: - Tokenizing
    private func processMessage(message:String) -> SlackMessage{
        var tokens = message.components(separatedBy: " ")
        tokens = tokens.filter { $0 != ""}
        
        var message = SlackMessage(messageType: .Error)
        //First Determine if we have a single Token (AKA Standalone Commands)
        if tokens.count == 1 {
            
            //print("Single Token \(tokens)")
            switch tokens[0].lowercased() {
            case "trucks":
                message.messageType = .Trucks
                message.singleToken = tokens[0].trimmingCharacters(in: .whitespacesAndNewlines)
                break
            case "locations":
                message.messageType = .Locations
                message.singleToken = tokens[0].trimmingCharacters(in: .whitespacesAndNewlines)
                break
            case "help":
                message.messageType = .Help
                message.singleToken = tokens[0].trimmingCharacters(in: .whitespacesAndNewlines)
                break
            case nearMeToken:
                message.messageType = .Special
                message.singleToken = tokens[0].trimmingCharacters(in: .whitespacesAndNewlines)
                break
            default:
                //Possible Single TruckName
                message.messageType = .TruckNames
                let truckNames = tokens[0]
                
                message.truckNames = filterTrucks(truckNames: [truckNames.trimmingCharacters(in: .whitespacesAndNewlines)])
                break
            }
            //print(message)
        }else{
            //We have a multiple token command. let's check it out
            if tokens.contains(where: {$0.caseInsensitiveCompare("trucks") == .orderedSame}) {
                //We have a trucks Request. Let's see what else we have
                if tokens.contains(where: {$0.caseInsensitiveCompare("at") == .orderedSame}) && tokens.contains(where: {$0.caseInsensitiveCompare("for") == .orderedSame}) {
                    //print("Trucks For Location & Day")
                    //print(tokens)
                    //need to parse out the locations & Days into arrays that we can use to send back in the returned array
                    if let atToken = tokens.index(of: "at"), let forToken = tokens.index(of: "for") {
                        var locations = ""
                        var daysOfWeek = [DayOfWeek]()
                        for i in ((atToken + 1 )..<forToken) {
                            locations += tokens[i]
                        }
                        
                        for i in ((forToken + 1 )..<tokens.count) {
                            if let day = DayOfWeek(rawValue: tokens[i]) {
                                daysOfWeek.append(day)
                            }
                            
                        }
                        message.messageType = .TrucksByLocationAndDay
                        
                        message.Locations = filterLocations(locations: locations.components(separatedBy: ","))
                        //message.Locations = locations.components(separatedBy: ",")
                        message.daysOfWeek = daysOfWeek
                        //print("Locations: \(locations)  DaysOfWeek: \(daysOfWeek)")
                        //print(message)
                    }
                    
                }else if tokens.contains(where: {$0.caseInsensitiveCompare("at") == .orderedSame}) {
                    //print("Trucks For Location")
                    if let atToken = tokens.index(of: "at") {
                        var locations = ""
                        for i in ((atToken + 1 )..<tokens.count) {
                            locations += tokens[i]
                        }
                        message.messageType = .TrucksByLocation
                        message.Locations = filterLocations(locations: locations.components(separatedBy: ","))
                        //message.Locations = locations.components(separatedBy: ",")
                        //print(message)
                        
                    }
                }else {
                    print("List out Trucks Please -- Shouldn't Get here")
                }
            } else {
                //Not A Locations Call (Assume this is a TruckName Call)
                if let forToken = tokens.index(where: {$0.caseInsensitiveCompare("for") == .orderedSame}) {
                    //print("TruckName For Day of Week")
                    //print("For Token index:\(forToken)")
                    var truckNames = ""
                    var daysOfWeek = [DayOfWeek]()
                    for i in 0..<forToken {
                        truckNames += tokens[i] + " "
                    }
                    
                    for i in ((forToken + 1 )..<tokens.count) {
                        if let day = DayOfWeek(rawValue: tokens[i]) {
                            daysOfWeek.append(day)
                        }
                        
                    }
                    truckNames = truckNames.trimmingCharacters(in: .whitespacesAndNewlines)
                    //print("Truck Names: \(truckNames) & Days of Week: \(daysOfWeek)")
                    message.messageType = .TruckNamesAndDay
                    message.daysOfWeek = daysOfWeek
                    message.truckNames = filterTrucks(truckNames: truckNames.components(separatedBy: ","))
                    //truckNames.components(separatedBy: ",")
                    //print(message)
                    
                } else {
                    //Request for a Truckname only
                    //print("TruckName only")
                    var truckNames = tokens.joined(separator: " ")
                    truckNames = truckNames.trimmingCharacters(in: .whitespacesAndNewlines)
                    message.messageType = .TruckNames
                    message.truckNames = filterTrucks(truckNames: truckNames.components(separatedBy: ","))
                    
                    //print(message)
                }
            }
            
            
        }
        
        return message
    }
    
 //MARK: - Data Fetch
    
    func getData() {
        
        do {
            let trucksResponse = try drop.client.get(truckURL).json
            
            if let trucks = trucksResponse?.array {
                truckList.removeAll()
                for item in trucks {
                    let truck = Truck(data: item)
                    truckList.append(truck)
                }
            }else {
                print("Error Getting Trucks Data")
            }

            print("Fetching Locations.....Standby")
            let locationsResponse = try drop.client.get(locationURL).json
            
            if let locations = locationsResponse?.object {
                locationList.removeAll()
                for location in locations {
                    let truckRoute = location.value.object?["truck_route"]?.string
                    //Check for Location
                    if let locationID = TruckLocations(rawValue: (location.value.object?["location_id"]?.string)!) {
                        //Do we have this location?
                        if locationList.contains(where: {$0.locationId == locationID}) {
                            //Add the information to the object
                            var currentLocation = locationList[(locationList.index(where: {$0.locationId == locationID}))!]
                            //check to see if we already have the day in the Location
                            //Split out the Days into an array in case of multiple days for the truck
                            if let daysArray = location.value.object?["day"]?.string?.components(separatedBy: ",") {
                                //Loop through the array and check for days
                                for item in daysArray {
                                    //We have that day so lets add the truck
                                    if currentLocation.days.contains(where: {$0.numericDay == item.int}) {
                                        //We have that day already. check to see if the truck already exists
                                        var day = currentLocation.days[currentLocation.days.index(where: {$0.numericDay == item.int})!]
                                        if day.trucks.contains(truckRoute!) {
                                            //do Nothing we have that already
                                        }else {
                                            day.trucks.insert(truckRoute!)
                                            currentLocation.days.remove(at: currentLocation.days.index(where: {$0.numericDay == item.int})!)
                                            currentLocation.days.insert(day)
                                            
                                        }
                                        
                                    } else {
                                        //We don't have that Day so create it and add the truck
                                        let day = Day(days: item, truckId: truckRoute!)
                                        currentLocation.days.insert(day)
                                    }
                                }
                                
                                locationList.remove(at: locationList.index(where: {$0.locationId == locationID})!)
                                locationList.insert(currentLocation)
                            }
                            
                        } else {
                            //We have a new Location (let's get that setup
                            locationList.insert(Location(data: location.value))
                            //print("Added Location: " + locationID.rawValue)
                        }
                    }
                    
                }
            }
            print("Finished getting Locations")
        }catch {
            print("We have an Error")
        }
        
    }
}


