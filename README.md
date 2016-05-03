# ManagedStatsOC

[![CI Status](http://img.shields.io/travis/Bob Pascazio/ManagedStatsOC.svg?style=flat)](https://travis-ci.org/Bob Pascazio/ManagedStatsOC)
[![Version](https://img.shields.io/cocoapods/v/ManagedStatsOC.svg?style=flat)](http://cocoapods.org/pods/ManagedStatsOC)
[![License](https://img.shields.io/cocoapods/l/ManagedStatsOC.svg?style=flat)](http://cocoapods.org/pods/ManagedStatsOC)
[![Platform](https://img.shields.io/cocoapods/p/ManagedStatsOC.svg?style=flat)](http://cocoapods.org/pods/ManagedStatsOC)


## Requirements

## Installation

To install it, simply add the following line to your Podfile:

pod 'ManagedStatsOC', :git => 'https://github.com/managedapps/ManagedStatsOC.git'

## Usage


Begin by setting up an account with [ManagedApps.](http://portal.managedapps.co) 

Tap on '+ New App' and enter the application name. 

Search for appKey and apiKey under 'MY APPS' -> 'Information' -> 'VIEW APP KEY' & 'VIEW API KEY'. This information will be used for the next step. 

## Objective - C

Add the following code to AppDelegate didFinishLaunchingWithOptions method,

 	[ManagedStats setAppKey:@"AppKey" setApiKey:@"ApiKey"];
 
    [ManagedStats appLaunched];


Add the following code to AppDelegate applicationWillEnterForeground method,

 	[ManagedStats sessionStart];
    


## Swift
Make sure you have 'use_frameworks!' as part of your podfile documentation. 


Add the following code to AppDelegate didFinishLaunchingWithOptions method,

		ManagedStats.setAppKey("", setApiKey: "")
        ManagedStats.appLaunched()
        
        
Add the following code to AppDelegate applicationWillEnterForeground method,

	 ManagedStats.sessionStart()
        
        
## Author

Bob Pascazio, bob@bytefly.com

## License

ManagedStatsOC is available under the MIT license. See the LICENSE file for more info.
