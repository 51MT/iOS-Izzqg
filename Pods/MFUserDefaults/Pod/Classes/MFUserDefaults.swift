// Copyright (c) 2015 MFox Studio http://mfoxstudio.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// A true defaults toolkit
public class MFUserDefaults {
    public static let sharedInstance = MFUserDefaults()

    private var queue: dispatch_queue_t!
    private var user: String!

    // Shared defaults related
    private var isSharedDefaultsReady = false
    private var needsSyncSharedDefaults = false
    private var sharedPlistFilePath: String!
    private var sharedDefaults: [String: AnyObject]!

    // User defaults related
    private var isUserDefaultsReady = false
    private var needsSyncUserDefaults = false
    private var userPlistFilePath: String?
    private var userDefaults: [String: AnyObject]!

    private init() {
        // Create the queue
        queue = dispatch_queue_create("ud.mf", DISPATCH_QUEUE_SERIAL)

        repeat {
            // Check the application support directory
            let dir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] + "/Defaults"

            var shouldCreateDir = true
            var isDir: ObjCBool = false
            if NSFileManager.defaultManager().fileExistsAtPath(dir, isDirectory: &isDir) {
                if isDir {
                    shouldCreateDir = false
                } else {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(dir)
                    } catch let error as NSError {
                        print("MFUserDefaults: removeItemAtPath error, \(error.localizedDescription)")
                        break
                    }
                }
            }

            if shouldCreateDir {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(dir, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print("MFUserDefaults: createDirectoryAtPath error, \(error.localizedDescription)")
                    break
                }
            }

            sharedPlistFilePath = dir + "/defaults.plist"
            if NSFileManager.defaultManager().fileExistsAtPath(sharedPlistFilePath) {
                if let content = NSDictionary(contentsOfFile: sharedPlistFilePath) as? [String: AnyObject] {
                    sharedDefaults = content
                } else {
                    sharedDefaults = [String: AnyObject]()
                }
            } else {
                isSharedDefaultsReady = NSFileManager.defaultManager().createFileAtPath(sharedPlistFilePath, contents: nil, attributes: nil)
                if !isSharedDefaultsReady {
                    break
                }
                sharedDefaults = [String: AnyObject]()
            }
            isSharedDefaultsReady = true
        } while false

        if isSharedDefaultsReady {
            let runLoop = CFRunLoopGetCurrent()
            let runLoopMode = kCFRunLoopDefaultMode
            let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.BeforeWaiting.rawValue, true, 0, { (_, activity) -> Void in
                self.synchronize()
            })
            CFRunLoopAddObserver(runLoop, observer, runLoopMode)
        }

        userDefaults = [String: AnyObject]()
    }
    
    public subscript(key: String, isSharedDefault: Bool) -> AnyObject? {
        get {
            return objectForKey(key, isSharedDefault: isSharedDefault)
        }
        set {
            setObject(newValue, forKey: key, isSharedDefault: isSharedDefault)
        }
    }

    public func currentUser() -> String? {
        guard isUserDefaultsReady else {
            return nil
        }

        return self.user
    }

    public func registerUser(user: String!) -> Bool {
        synchronize()

        var success = false
        dispatch_sync(queue) { () -> Void in
            repeat {
                // the length of user should be greater than 0
                if user.characters.count == 0 {
                    break
                }

                // if the user is the current user, return true directly
                if self.user != nil && user == self.user {
                    success = true
                    break
                }

                let userDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
                    + "/Defaults/\(user)/"
                var shouldCreateDir = true
                var isDir: ObjCBool = false
                if NSFileManager.defaultManager().fileExistsAtPath(userDir, isDirectory: &isDir) {
                    if isDir {
                        shouldCreateDir = false
                    } else {
                        do {
                            try NSFileManager.defaultManager().removeItemAtPath(userDir)
                        } catch let error as NSError {
                            print("MFUserDefault: removeItemAtPath error, \(error.localizedDescription)")
                            break
                        }
                    }
                }

                if shouldCreateDir {
                    do {
                        try NSFileManager.defaultManager().createDirectoryAtPath(userDir, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        print("MFUserDefault: createDirectoryAtPath error, \(error.localizedDescription)")
                        break
                    }
                }

                self.userPlistFilePath = userDir + "defaults.plist"
                if NSFileManager.defaultManager().fileExistsAtPath(self.userPlistFilePath!) {
                    if let content = NSDictionary(contentsOfFile: self.userPlistFilePath!) as? [String: AnyObject] {
                        self.userDefaults = content
                    } else {
                        self.userDefaults = [String: AnyObject]()
                    }
                } else {
                    success = NSFileManager.defaultManager()
                        .createFileAtPath(self.userPlistFilePath!, contents: nil, attributes: nil)
                    if !success {
                        break
                    }
                    self.userDefaults = [String: AnyObject]()
                }
                success = true
            } while false

            self.isUserDefaultsReady = success
            if success {
                self.user = user
            } else {
                self.user = nil
                self.userPlistFilePath = nil
                self.userDefaults = [String: AnyObject]()
            }
        }

        return success
    }

    public func registerDefaults(registrationDictionary: [String : AnyObject], isSharedDefault: Bool = false) {
        dispatch_sync(queue) { () -> Void in
            if (isSharedDefault && !self.isSharedDefaultsReady)
                || (!isSharedDefault && !self.isUserDefaultsReady) {
                    return
            }

            if !isSharedDefault && self.user==nil {
                print("registerDefaults failed, call registerUser(_:) first. or set isSharedDefault true")
                return
            }

            for (registrationKey, registrationValue) in registrationDictionary {
                let result = isSharedDefault ? self.sharedDefaults[registrationKey] : self.userDefaults[registrationKey]
                if result == nil {
                    isSharedDefault ? (self.sharedDefaults[registrationKey]=registrationValue) : (self.userDefaults[registrationKey]=registrationValue)
                }
            }
        }
    }

    public func resetUserDefaults(isSharedDefault isSharedDefault: Bool = false) {
        dispatch_sync(queue) { () -> Void in
            if (isSharedDefault && !self.isSharedDefaultsReady)
                || (!isSharedDefault && !self.isUserDefaultsReady) {
                    return
            }

            if !isSharedDefault && self.user==nil {
                print("registerDefaults failed, call registerUser(_:) first. or set isSharedDefault true")
                return
            }

            isSharedDefault ? self.sharedDefaults.removeAll() : self.userDefaults.removeAll()
            isSharedDefault ? (self.needsSyncSharedDefaults=true) : (self.needsSyncUserDefaults=true)
        }
    }

    public func removeObjectForKey(defaultName: String, isSharedDefault: Bool = false) {
        dispatch_sync(queue) { () -> Void in
            if (isSharedDefault && !self.isSharedDefaultsReady)
                || (!isSharedDefault && !self.isUserDefaultsReady) {
                    return
            }

            if !isSharedDefault && self.user==nil {
                print("removeObjectForKey failed, call registerUser(_:) first. or set isSharedDefault true")
                return
            }

            isSharedDefault ? (self.sharedDefaults.removeValueForKey(defaultName)) : (self.userDefaults.removeValueForKey(defaultName))
        }
    }

    public func synchronize() -> Bool {
        var userDefaultsSynchronized = true
        var sharedDefaultsSynchronized = true

        dispatch_sync(queue) { () -> Void in
            // Synchronize the shared defaults
            if self.needsSyncSharedDefaults {
                let plistDic = NSDictionary(dictionary: self.sharedDefaults)
                sharedDefaultsSynchronized = plistDic.writeToFile(self.sharedPlistFilePath, atomically: true)
                self.needsSyncSharedDefaults = !sharedDefaultsSynchronized
            }

            if self.needsSyncUserDefaults {
                if let userPlistFilePath = self.userPlistFilePath {
                    let plistDic = NSDictionary(dictionary: self.userDefaults)
                    userDefaultsSynchronized = plistDic.writeToFile(userPlistFilePath, atomically: true)
                    self.needsSyncUserDefaults = !userDefaultsSynchronized
                }
            }
        }

        return userDefaultsSynchronized && sharedDefaultsSynchronized
    }
}

// MARK: - Setters Extention
public extension MFUserDefaults {
    public func setString(value: String?, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(value, forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setData(value: NSData?, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(value, forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setDate(value: NSDate?, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(value, forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setInteger(value: Int, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(NSNumber(integer: value), forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setFloat(value: Float, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(NSNumber(float: value), forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setDouble(value: Double, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(NSNumber(double: value), forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setBool(value: Bool, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(NSNumber(bool: value), forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setURL(url: NSURL?, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(url?.absoluteString, forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setArray(value: [AnyObject]?, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(value, forKey: defaultName, isSharedDefault: isSharedDefault)
    }

    public func setDictionary(value: [String: AnyObject]?, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        return setObject(value, forKey: defaultName, isSharedDefault: isSharedDefault)
    }


    private func setObject(value: AnyObject?, forKey defaultName: String, isSharedDefault: Bool = false) -> Bool {
        guard let value = value else {
            removeObjectForKey(defaultName)
            return true
        }

        var success = false

        dispatch_sync(queue) { () -> Void in
            repeat {
                if (isSharedDefault && !self.isSharedDefaultsReady)
                    || (!isSharedDefault && !self.isUserDefaultsReady) {
                        break
                }

                if !isSharedDefault && self.user==nil {
                    print("setValue failed, call registerUser(_:) first. or set isSharedDefault true")
                    break
                }

                isSharedDefault ? (self.sharedDefaults[defaultName]=value) : (self.userDefaults[defaultName]=value)
                success = true
            } while false

            if success {
                isSharedDefault ? (self.needsSyncSharedDefaults=true) : (self.needsSyncUserDefaults=true)
            }
        }

        return success
    }
}

// MARK: - Getters Extension
public extension MFUserDefaults {
    public func stringForKey(defaultName: String, isSharedDefault: Bool = false) -> String? {
        return objectForKey(defaultName, isSharedDefault: isSharedDefault) as? String
    }

    public func dataForKey(defaultName: String, isSharedDefault: Bool = false) -> NSData? {
        return objectForKey(defaultName, isSharedDefault: isSharedDefault) as? NSData
    }

    public func dateForKey(defaultName: String, isSharedDefault: Bool = false) -> NSDate? {
        return objectForKey(defaultName, isSharedDefault: isSharedDefault) as? NSDate
    }

    public func integerForKey(defaultName: String, isSharedDefault: Bool = false) -> Int {
        guard let number = objectForKey(defaultName, isSharedDefault: isSharedDefault) as? NSNumber else {
            return 0
        }

        return number.integerValue
    }

    public func floatForKey(defaultName: String, isSharedDefault: Bool = false) -> Float {
        guard let number = objectForKey(defaultName, isSharedDefault: isSharedDefault) as? NSNumber else {
            return 0.0
        }

        return number.floatValue
    }

    public func doubleForKey(defaultName: String, isSharedDefault: Bool = false) -> Double {
        guard let number = objectForKey(defaultName, isSharedDefault: isSharedDefault) as? NSNumber else {
            return 0.0
        }

        return number.doubleValue
    }

    public func boolForKey(defaultName: String, isSharedDefault: Bool = false) -> Bool {
        guard let number = objectForKey(defaultName, isSharedDefault: isSharedDefault) as? NSNumber else {
            return false
        }

        return number.boolValue
    }

    public func URLForKey(defaultName: String, isSharedDefault: Bool = false) -> NSURL? {
        guard let urlString = objectForKey(defaultName, isSharedDefault: isSharedDefault) as? String else {
            return nil
        }

        return NSURL(string: urlString)
    }

    public func arrayForKey(defaultName: String, isSharedDefault: Bool = false) -> [AnyObject]? {
        return objectForKey(defaultName, isSharedDefault: isSharedDefault) as? [AnyObject]
    }

    public func dictionaryForKey(defaultName: String, isSharedDefault: Bool = false) -> [String: AnyObject]? {
        return objectForKey(defaultName, isSharedDefault: isSharedDefault) as? [String: AnyObject]
    }

    private func objectForKey(defaultName: String, isSharedDefault: Bool = false) -> AnyObject? {
        var result: AnyObject?

        dispatch_sync(queue) { () -> Void in
            repeat {
                if (isSharedDefault && !self.isSharedDefaultsReady)
                    || (!isSharedDefault && !self.isUserDefaultsReady) {
                        break
                }

                if !isSharedDefault && self.user==nil {
                    print("stringForKey failed, call registerUser(_:) first. or set isSharedDefault true")
                    break
                }

                result = isSharedDefault ? self.sharedDefaults[defaultName] : self.userDefaults[defaultName]
            } while false
        }

        return result
    }
}

extension MFUserDefaults: CustomDebugStringConvertible {
    public var debugDescription: String { get {
        return "MFUserDefaults, User: \(user), State: UserMode(\(isUserDefaultsReady)), ShareMode(\(isSharedDefaultsReady))\n"
        }
    }
}