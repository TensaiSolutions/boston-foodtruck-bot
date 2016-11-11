//
//  main.swift
// test 1
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
import Foundation

let VERSION = "0.0.1"

let config = try Config(prioritized: [.directory(root: workingDirectory + "Config/")])
guard let token = config["bot-config", "token"]?.string else { throw BotError.missingConfig }
guard let location_url = config["bot-config", "location_url"]?.string else { throw BotError.missingConfig }
guard let truck_url = config["bot-config", "truck_url"]?.string else { throw BotError.missingConfig }
guard let near_me_location = config["bot-config", "near_me_locations"]?.array else { throw BotError.missingConfig }
guard let near_me_token = config["bot-config", "near_me_token"]?.string else { throw BotError.missingConfig }

let foodTruckBot = FoodTruckBot(token: token)

DataManager.instance.truckURL = truck_url
DataManager.instance.locationURL = location_url
DataManager.instance.nearMeToken = near_me_token.lowercased()
DataManager.instance.loadTrucksNearMe(data: near_me_location)

//Get and Setup The Data
DataManager.instance.getData()
foodTruckBot.client.connect()

let timer = repeater(1.hour) {
    DataManager.instance.getData()
}

RunLoop.main.run()
