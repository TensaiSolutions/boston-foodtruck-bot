//
//  Locations.swift
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

import Foundation
import Polymorphic


//Food Truck Location Structure
struct Location: Hashable {
    let locationId:TruckLocations
    let neighborhood:String?
    let message:String?
    let location:String?
    let lat:Double?
    let long:Double?
    var days = Set<Day>()
    var hashValue: Int {
        return locationId.hashValue
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.locationId == rhs.locationId
    }
    
    init(data: Polymorphic) {
        let locationID = TruckLocations(rawValue: (data.object?["location_id"]?.string)!)
        locationId = locationID!
        neighborhood = data.object?["neighborhood"]?.string
        message = data.object?["message"]?.string
        location = data.object?["location"]?.string
        lat = data.object?["lat"]?.double
        long = data.object?["lng"]?.double
        if let daysArray = data.object?["day"]?.string?.components(separatedBy: ",") {
            for day in daysArray {
                let newDay = Day(days: day.string!, truckId: (data.object?["truck_route"]?.string)!)
            //get the DayOf Week
                days.insert(newDay)
            }
        }
    }
    
}

struct Day: Hashable {
    let numericDay:Int
    let dayOfWeek:DayOfWeek?
    var trucks = Set<String>()
    var hashValue: Int {
        return numericDay.hashValue
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.numericDay == rhs.numericDay
    }
    
    init(days:String, truckId:String) {
        numericDay = days.int!
        dayOfWeek = DayOfWeek.fromNumber(number: (numericDay))
        if trucks.contains(truckId) {
            //do nothing we have that one already
        } else {
            trucks.insert(truckId)
        }
    }
    
}


enum TruckLocations:String {
    case Dewey = "dewey"
    case GreenwayDeweyCongress = "greenway-dewey-congress"
    case ClarendonTrinity = "clarendon-trinity"
    case GreenwayRowesWharf = "greenway-roweswharf"
    case BostonCommon = "bostoncommon"
    case Prudential = "prudential"
    case SeaportWormwood = "seaport-wormwood"
    case ConstantContact = "constantcontact"
    case FenwayLandmark = "fenway-landmark"
    case HarvardScience = "harvard-science"
    case BUEast = "bu-east"
    case MassGeneralHospital = "mgh"
    case StuartTrinity = "stuart-trinity"
    case WaterTownArsenal = "watertown-arsenal"
    case CityHallPlaza = "cityhallplaza"
    case BostonPublicLibrary = "bostonpubliclibrary"
    case InnovationDistrict = "innovationdistrict"
    case ChinatownGate = "chinatown-gate"
    case BostonMedicalCenter = "bmc"
    case WatertownAthena = "watertown-athena"
    case Longwood = "longwood"
    case Burlington = "burlington"
    case NorthEasternUniversity = "neu"
    case AlewifeVECNA = "alewife-vecna"
    case Federal101 = "federal-101"
    case GreenwayMilk = "greenway-milk"
    case Lexington = "lexington"
    case GreenwayCarousel = "greenway-carousel"
    case SOWA = "sowa"
    case FinancialMilkKilby = "financial-milk-kilby"
    case DorchesterLenaPark = "dorchester-lena-park"
    case CharlestownBHA = "charlestown-bha"
    case NorthEasternCentennial = "neu-centennial"
    case DorchesterEpiphany = "dorchester-epiphany"
    case CharlestownEdwards = "charlestown-edwards"
    case DorchesterOlmstedGreen = "dorchester-olmsted-green"
    case SouthEndCommunityHealth = "southend-community-health"
    case CharlestownConstitutionCoop = "charlestown-constitution-coop"
    case MaverickSquare = "maverick-square"
    case BrighamWomens = "brighamwomens"
    case MITKendall = "mit-kandell"
    case FinancialHighBatteryMarch = "financial-high-batterymarch"
    case BUWest = "bu-west"
    case AlewifeCBRE = "alewife-cbre"
    case Courthouse = "courthouse"
    case Charlestown = "charlestown"
    case GreenwayPurchaseHigh = "greenway-purchasehigh"
    case SouthEndOpenMarketInkBlock = "southendopenmarket-inkblock"
    case ChinatownBoylstonWashington = "chinatown-boylston-washington"
    case CambridgeRogers = "cambridge-rogers"
    
    static let locations = [Dewey, GreenwayDeweyCongress, ClarendonTrinity, GreenwayRowesWharf, BostonCommon, Prudential, SeaportWormwood, ConstantContact, FenwayLandmark, HarvardScience,
    BUEast, MassGeneralHospital, StuartTrinity, WaterTownArsenal, CityHallPlaza, BostonPublicLibrary, InnovationDistrict, ChinatownGate, BostonMedicalCenter, WatertownAthena, Longwood, Burlington,
    NorthEasternUniversity, AlewifeVECNA, Federal101, GreenwayMilk, Lexington, GreenwayCarousel, SOWA, FinancialMilkKilby, DorchesterLenaPark, CharlestownBHA, NorthEasternCentennial, DorchesterEpiphany,
    CharlestownEdwards, DorchesterOlmstedGreen, SouthEndCommunityHealth, CharlestownConstitutionCoop, MaverickSquare, BrighamWomens, MITKendall, FinancialHighBatteryMarch, BUWest, AlewifeCBRE, Courthouse,
    GreenwayPurchaseHigh, SouthEndOpenMarketInkBlock, ChinatownBoylstonWashington, CambridgeRogers]
    
}















