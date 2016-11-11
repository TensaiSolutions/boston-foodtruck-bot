//
//  FoodTruckBot.swift
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

import SlackKit

class FoodTruckBot: MessageEventsDelegate {
    
    let client:SlackClient
    
    init(token: String) {
        client = SlackClient(apiToken: token)
        client.messageEventsDelegate = self
    }
    
    //MARK: MessageEventsDelegate
    func messageReceived(message: Message) {
        print("We Got this Message in FoodTruckBot \(message.text)")
        listen(message: message)
    }
    
    func messageSent(message: Message) {}
    func messageChanged(message: Message) {}
    func messageDeleted(message: Message?) {}
    
    //MARK: FoodTruck Internal Logic
    private func listen(message: Message) {
        //Check to see if the user is mentioned
        if let id = client.authenticatedUser?.id {
            if message.text?.contains(query: id) == true {
                //Need to strip out user from the text in the message.
                handleMessage(message: message)
            }
        }
    }
    
    private func handleMessage(message: Message) {
        if var text = message.text, let channel = message.channel {
            
            //Strip out the Bot's UserID
            let userID = client.authenticatedUser?.id
            text = text.replacingOccurrences(of: "<@\(userID!)>", with: "")
            
            let returnText = DataManager.instance.handleMessage(message: text.slackFormatRemoveEscaping())
            client.sendMessage(message: returnText, channelID: channel)
        }
    }
    
    
    
}

extension String {
    func slackFormatRemoveEscaping() -> String {
        var escapedString = self
        escapedString = escapedString.replacingOccurrences(of: "&amp;", with: "&")
        escapedString = escapedString.replacingOccurrences(of: "&lt;", with: "<")
        escapedString = escapedString.replacingOccurrences(of: "&gt;", with: ">")
        return escapedString
    }

}
