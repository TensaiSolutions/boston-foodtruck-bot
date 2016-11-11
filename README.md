![Swift Version](https://img.shields.io/badge/Swift-3.0-orange.svg) ![Platforms](https://img.shields.io/badge/Platforms-macOS,linux-lightgrey.svg) ![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg) [![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
##Food Truck Slack Bot for Boston Food Trucks written in Swift
###Description
This is a Food Truck Slack Bot for Linux written in Swift. It's intended to allow users to query the bot for their favorite Food Trucks and Locations to determine what to eat. It uses the [SlackKit-Vapor Framework](https://github.com/TensaiSolutions/SlackKit-Vapor). Inspired by the Node Version [boston-food-truck-slack-bot](https://github.com/jstruzik/boston-food-truck-slack-bot)


###Installation

#### Create a new bot in Slack

1. Under "Customize Slack" > "Configure" > "Custom Integrations" select "Bots"
2. Choose "Add Configuration"
3. Create a username for your Slack bot. We use **@foodtruckbot** but it's up to you.
4. Choose an icon for the Slack bot.
5. Grab the API token from the settings page, you'll need this when you set up the bot server.
- Clone this repo to your machine.
- Update the Config File with the Bot Token
- Configure the NearMe Locations
- From the command line
```
Swift build   
```
- Run The App
```
.build/debug/FoodTruckBot
```

####Modify the bot-config file
- Add Bot Token
```
    "token": "xoxb-*****",
```
- Update Location List for "NearMe" Locations
```
"near_me_locations" : ["dewey","greenway-dewey-congress","greenway-roweswharf"]
```
- Update Token (if you want something more Meaningful). Must be a single Word(no spaces).
```
"near_me_token" : "NearMe"
```

####Development
To Modify the Bot in Xcode, simply use SwiftPM.
```
swift build
swift swift package generate-xcodeproj
```

####Bot Commands
The FoodTruck Bot currently supports the following Commands:

`Help` -> Lists the Commands the Bot will respond to

`Trucks` -> List all the Food Trucks that the Bot knows

`Locations` -> List all the Locations for FoodTrucks

`NearMe` -> List all the Food Trucks near Me for Today based on the configured list

`Trucks at Location(s)` -> Lists the trucks for Today at the given Locations
>_Example:_ Trucks at watertown-athena, brighamwomen

`Trucks at Location(s) for Days` -> Lists trucks for the given day(s) at the given Locations
>_Example:_ Trucks at greenway-dewey-congress, financial-milk-kilby for Monday, Tuesday

`Truck Name(s)` -> Retrieve the requested Truck(s) Locations for Today
>_Example:_ Blazing Salads, Bon Me

`Truck Name(s) for Days` -> Retrieve the requested Truck(s) Locations for the given Day(s)
>_Example:_ Blazing Salads, Bon Me for Monday,Tuesday

####Truck Locations

- `dewey` --> Dewey Square, Across from South Station on the Greenway
- `greenway-dewey-congress` --> Greenway, Dewey Square Park at Congress St
- `clarendon-trinity` --> Copley Square, Clarendon St at Trinity Church
- `greenway-roweswharf` --> Greenway, Rowes Wharf Plaza, High Street and Atlantic Ave
- `bostoncommon` --> Boston Commons, next to Brewer Fountain and the Freedom Trail. (near Park St station)
- `prudential` --> Prudential, in front of Christian Science Centers Childrens Fountain
- `seaport-wormwood` --> Seaport, Wormwood Street
- `constantcontact` --> Constant Contact, 1601 Trapelo Road, Waltham
- `fenway-landmark` --> Fenway, Landmark Building, 343 Park Drive
- `harvard-science` --> Harvard Science Center, 1 Oxford St, Cambridge
- `bu-east` --> BU East, on Commonwealth Ave at Silber Way
- `mgh` --> Mass General Hospital, Blossom Street at Emerson Place
- `stuart-trinity` --> Back Bay, Stuart St. at Trinity Place
- `watertown-arsenal` --> The Arsenal Project, 485 Arsenal St, Watertown
- `cityhallplaza` --> City Hall Plaza, Fisher Park
- `bostonpubliclibrary` --> Boston Public Library
- `innovationdistrict` --> Innovation District, Seaport Blvd at Boston Wharf Rd
- `chinatown-gate` --> Chinatown Gate, Beach St
- `bmc`--> Boston Medical Center on Harrison Ave
- `watertown-athena` --> Athena Health, School St. Watertown
- `longwood` --> Longwood Medical Area, Blackfan St
- `burlington` --> 44 Mall Road, Burlington
- `neu` --> NEU, on Opera Place at Huntington Ave
- `alewife-vecna` --> 36 Cambridge Park Drive, VECNA, Alewife
- `federal-101` --> 101 Federal Street
- `greenway-milk` --> Greenway, Rings Fountain at Milk St
- `lexington` --> 101 Hartwell Avenue, Lexington
- `greenway-carousel` --> The Greenway Carousel
- `sowa` --> SoWa Open Market, Harrison Avenue
- `financial-milk-kilby` --> Financial District, Milk and Kilby Streets
- `dorchester-lena-park` --> Dorchester, Lena Park Community Center, 150 American Legion Highway
- `charlestown-bha` --> Charlestown BHA, 55 Monument Street
- `neu-centennial` --> NEU, Centennial Common, 40 Leon Street
- `dorchester-epiphany` --> Dorchester, Epiphany School, 154 Centre Street
- `charlestown-edwards` --> Charlestown, Edwards Middle School Parking Lot, 321 Main Street
- `dorchester-olmsted-green` --> Dorchester, Hearth at Olmsted & Green, 2 Kingbird Road
- `southend-community-health` --> South End Community Health Center, 1601 Washington Street
- `charlestown-constitution-coop` --> Charlestown, Constitution Co-op, 42 Park St
- `maverick-square` --> Maverick Square T Stop
- `brighamwomens` --> Brigham & Women’s Hospital, 45 Shattuck St
- `mit-kandell` --> Carleton St., Kendall T Station
- `financial-high-batterymarch` --> Financial District, High St. and Batterymarch St. behind Howl at the Moon
- `bu-west` --> BU West, 855 Commonwealth Ave
- `alewife-cbre` --> CBRE 150 Cambridge Park Drive Cambridge
- `courthouse` --> Courthouse Station
- `charlestown` --> Charlestown Navy Yard at Baxter Road
- `greenway-purchasehigh` --> Greenway, Purchase St & High St
- `southendopenmarket-inkblock` --> South End Open Market at Ink Block
- `chinatown-boylston-washington` --> Chinatown, Boylston St & Washington St
- `cambridge-rogers` --> 1 Rogers Street, Cambridge


###Get In Touch
[@TensaiSolutions](https://twitter.com/TensaiSolutions)

<sidellp@gmail.com>
