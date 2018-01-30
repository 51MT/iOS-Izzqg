# MFUserDefaults

[![CI Status](http://img.shields.io/travis/yebw/MFUserDefaults.svg?style=flat)](https://travis-ci.org/yebw/MFUserDefaults)
[![Version](https://img.shields.io/cocoapods/v/MFUserDefaults.svg?style=flat)](http://cocoapods.org/pods/MFUserDefaults)
[![License](https://img.shields.io/cocoapods/l/MFUserDefaults.svg?style=flat)](http://cocoapods.org/pods/MFUserDefaults)
[![Platform](https://img.shields.io/cocoapods/p/MFUserDefaults.svg?style=flat)](http://cocoapods.org/pods/MFUserDefaults)

## Introduction
A lightweight toolkit used to save settings for either application or specified user.

## Requirements	
* iOS 8.0+
* Xcode 7

## Integration

### CocoaPods	
MFUserDefaults is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```
platform :ios, '8.0'	
use_frameworks!	

target 'MyApp' do	
pod 'MFUserDefaults', :git => 'https://github.com/yebw/MFUserDefaults.git'
end
```

Note that this requires your iOS deployment target to be at least 8.0.

### Carthage
Carthage (iOS 8+)

You can use Carthage to install MFUserDefaults by adding it to your Cartfile:

```
github "yebw/MFUserDefaults" ~> 1.0
```


## Usage

##### 1. Configuration	
If you want to save settings to a specified user. you need to register the user first:

```
MFUserDefaults.sharedInstance().register("John")
```

If your only use this toolkit to save the application settings which is not relevent with any account in your user-system, you have nothing to configuration, but in this situation, you should always aware of set isSharedDefault parameter true, otherwise, you will get an unexpected result.

##### 2. Setters
Save a value which is irrelevant to current user, for example, you may want to remember the date when the application is installed:

```
MFUserDefaults.sharedInstance.setDate(NSDate(), forKey: "DateInstalled", isSharedDefault: true)

// or
MFUserDefaults.sharedInstance["DateInstalled", true] = NSDate()
```

isSharedDefault is a optional parameter with a default value false. As already mentioned above, your should set it true explicitly if you are saving a user-irrelevant property.

Save the name for a specified user:	

```
// MFUserDefaults.sharedInstance.registerUser("john") should already invoked

MFUserDefault.sharedInstance.setString("John Snow", forKey: "name")

// Or
MFUserDefault.sharedInstance.setString("John Snow", forKey: "name", isSharedDefault: false)

// Or 
MFUserDefaults.sharedInstance["name", false] = "John Snow"
```

Save the age for for a specified user:	

```
MFUserDefaults.sharedInstance.setInteger(25, forKey: "age")

// Or
MFUserDefaults.sharedInstance.setInteger(25, forKey: "age", isSharedDefault: false)

// Or 
MFUserDefaults.sharedInstance["age", false] = 25
```

NOTE: Just like NSUserDefaults, MFUserDefaults doesn't write the in-memory defaults to disk immediatly, you can call synchronize method if you want to.  The synchronize method, which is automatically invoked at a proper time, keeps the in-memory cache in sync with a user’s defaults plist file.

##### 3. Getters	
The way to fetch the value is also very intuitive:

Fetch the date of application installed:	

```
let date = MFUserDefaults.sharedInstance.dateForKey("DateInstalled", isSharedDefault: true)

\\ or
let date = MFUserDefaults.shareInstance["DateInstalled", true] as? NSDate
```

Fetch the name of current user:

```
let name = MFUserDefaults.shareInstance.stringForKey("name")

or 
let name = MFUserDefaults.shareInstance.stringForKey("name", isSharedDefault: false)

or
let name = MFUserDefaults.shareInstance["name", false] as? String
```

Fetch the age of current user:

```
let age = MFUserDefaults.shareInstance.integerForKey("age")

or 
let age = MFUserDefaults.shareInstance.integerForKey("age", isSharedDefault: false)

or
let age = MFUserDefaults.shareInstance["age", false] as? Int
```

#### 4. Others
* resetUserDefaults: reset the defaults
* registerDefaults: initialize the defaults
* removeObjectForKey: remove the value for the key
* synchronize: write the in-memory defaults to disk immediatly

## Author

yebw, yebingwei@gmail.com


## License

MFUserDefaults is available under the MIT license. See the LICENSE file for more info.
