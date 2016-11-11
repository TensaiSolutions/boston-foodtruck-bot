//
//  Truck.swift
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

struct Truck {
    
    let routeName: String?
    let name: String?
    let foodType:String?
    let webSite: String?
    let logo: String?
    let truckColor:String?
    let description:String?
    let popularDish:String?
    let tidbit:String?
    let instagramId:String?
    let yelpRating:String?
    var yelpRatingEmoji:String?
    let twitterHandle:String?
    var twitter:String?
    let twitterWidgetId:String?
    let tweet:String?
    let facebook:String?
    let instagram:String?
    let yelp:String?
    let foodTypes:[FoodType]?
    var foodTypeEmoji:String?

    
//MARK: - Init
    init(data: Polymorphic) {
        routeName = data.object?["route_name"]?.string
        name = data.object?["name"]?.string
        foodType = data.object?["food_type_single"]?.string
        webSite = data.object?["website"]?.string
        logo = data.object?["logo"]?.string
        truckColor = data.object?["truck_color"]?.string
        description = data.object?["description"]?.string
        popularDish = data.object?["popular_dish"]?.string
        tidbit = data.object?["tidbit"]?.string
        instagramId = data.object?["instagram_id"]?.string
        yelpRating = data.object?["yelp_rating"]?.string
        twitterHandle = data.object?["twitter"]?.string
        twitterWidgetId = data.object?["twitter_widget_id"]?.string
        tweet = data.object?["tweet"]?.string
        facebook = data.object?["facebook"]?.string
        instagram = data.object?["instagram"]?.string
        yelp = data.object?["baja-taco-truck-boston"]?.string
        foodTypes = []
        if let foodTypeArray = data.object?["food_type"]?.array {
            for food in foodTypeArray {
                let newFood = FoodType(typeName: food.object?["typename"]?.string , typeIcon: food.object?["typeicon"]?.string)
                foodTypes?.append(newFood)
            }
        }
        
        setFoodTypeEmoji()
        setYelpEmoji()
        setTwitter()
        
    }
//MARK: - Helper Functions
    private mutating func setFoodTypeEmoji() {
        if let foodType = self.foodType {
            switch  foodType {
            case "Mexican":
                self.foodTypeEmoji = ":taco:"
                return
            case "Asian":
                self.foodTypeEmoji = ":ramen:"
                return
            case "Healthy":
                self.foodTypeEmoji = ":apple:"
                return
            case "American":
                self.foodTypeEmoji = ":us:"
                return
            case "International":
                self.foodTypeEmoji = ":earth_americas:"
                return
            case "Sandwiches":
                self.foodTypeEmoji = ":bread:"
                return
            case "Burgers":
                self.foodTypeEmoji = ":hamburger:"
                return
            case "Dessert":
                self.foodTypeEmoji = ":cake:"
                return
            case "Pizza":
                self.foodTypeEmoji = ":pizza:"
                return
            case "Drinks":
                self.foodTypeEmoji = ":tropical_drink:"
                return
            case "Local":
                self.foodTypeEmoji = ":tractor::fork_and_knife:"
                return
            default:
            self.foodTypeEmoji = ""
            }
        }
    }
    
    private mutating func setYelpEmoji() {
        if let starRating = self.yelpRating?.double {
            let stars =  Int(starRating)
                var emojiStar = ""
                for _ in 1...stars {
                    emojiStar += ":star:"
                }
                self.yelpRatingEmoji = emojiStar
        }
        
    }
    
    private mutating func setTwitter() {
        if let handle = self.twitterHandle {
            self.twitter = "https://twitter.com/\(handle)"
        }
    }
    
}

struct FoodType {
    let typeName:String?
    let typeIcon:String?
}


