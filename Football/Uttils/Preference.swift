//
//  Preference.swift
//  Photo Video Maker
//
//  Created by jksol IMAC on 15/04/23.
//

import UIKit

class Preference: NSObject {

    static let sharedInstance = Preference()
    
    let IS_SUBSCRIBE                      = "IS_SUBSCRIBE_KEY"
    let App_LANGUAGE_KEY                  = "AppLanguageKey"
    let SHOW_HOME                         = "SHOW_HOME"
    let SHOW_LANGUAGE                     = "SHOW_LANGUAGE"
    let SHOW_PERMISSION                   = "SHOW_PERMISSION"
    let SHOW_CONFIRM_PRIVACY_SCREEN       = "SHOW_CONFIRM_PRIVACY_SCREEN_KEY"
    let REPORT_COUNT                      = "REPORT_COUNT"
    let SHOW_DARKMODE                     = "SHOW_DARKMODE"
    let SHOW_RATE_US                      = "SHOW_RATE_US"
    let IMPORT_IMAGES                     = "AUTO_IMPORT_IMAGES"
    let IMPORT_VIDEOS                     = "AUTO_IMPORT_VIDEOS"
    let INTRO_ONE                         = "SHOW_INTRO_ONE"
    let INTRO_TWO                         = "SHOW_INTRO_TWO"
    let INTRO_THREE                       = "SHOW_INTRO_THREE"
    let SENDER_SIZE                       = "SENDER_SIZE"
    let RECEIVER_SIZE                     = "RECEIVER_SIZE"
    let FIRST_TIME                        = "FirstTime"
    let FIRSTE_TIME_RATE                  = "FirstTimeRate"
    let SECOND_TIME_RATE                  = "SecondTime"
    let SHOW_TRANSFER_RATE                = "SHOW_TRANSFER_RATE"
    let RATE_DONE                         = "RATE_DONE"
    let COME_FROM_ITEM_PICKER             = "COME_FROM_ITEM_PICKER"
    let CHECK_RATE                        = "CHECK_RATE"
    let VIDEO_COUNT                       = "VIDEO_COUNT"
    let SCREEN_URL                        = "SCREEN_URL"
    let BATTERY_ANIMATION                 = "BATTERY_ANIMATION"
    let PROFILE_IMG                       = "PROFILE_IMG"
    let EMAILID                           = "EMAIL-ID"
    let NICKNAME                          = "NICKNAME"
    let GENDER                            = "GENDER"
    let AGE                               = "AGE"
    let NAME                              = "NAME"
    let APP_TERMINATE                     = "APP_TERMINATE"
}

func setDataToPreference(data: AnyObject, forKey key: String) {
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

func getDataFromPreference(key: String) -> AnyObject? {
    return UserDefaults.standard.object(forKey: key) as AnyObject?
}

func removeDataFromPreference(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaultValues() {
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}

// MARK: - Subscribe Methods
func setIsUserSubscribe(isSubscribe: Bool) {
    setDataToPreference(data: isSubscribe as AnyObject, forKey: Preference.sharedInstance.IS_SUBSCRIBE)
}

func isUserSubscribe() -> Bool {
    let isAccepted = getDataFromPreference(key: Preference.sharedInstance.IS_SUBSCRIBE)
    return isAccepted == nil ? false : (isAccepted as! Bool)
}

// MARK: - Subscribe Methods
func setIsSenderSize(isSender: Double) {
    setDataToPreference(data: isSender as AnyObject, forKey: Preference.sharedInstance.SENDER_SIZE)
}

func isSenderSize() -> Double {
    let isAccepted = getDataFromPreference(key: Preference.sharedInstance.SENDER_SIZE)
    return isAccepted as! Double
}

// Show Language Screen

func setLanguageCode(str:String){
    UserDefaults.standard.set(str, forKey: Preference.sharedInstance.App_LANGUAGE_KEY)
}

func getLanguageCode() -> String{
    let code = UserDefaults.standard.object(forKey: Preference.sharedInstance.App_LANGUAGE_KEY) as? String
    if code == nil {
        return "en"
    }else{
        return code!
    }
}

// Show Intro Screen

func setIsShowHome(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.SHOW_HOME)
}

func isShowHome() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.SHOW_HOME)
    return status
}

// Show Parmission Screen

func setIsPermission(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.SHOW_PERMISSION)
}

func isShowPermission() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.SHOW_PERMISSION)
    return status
}

// Show Lan Screen

func setIsLanguage(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.SHOW_LANGUAGE)
}

func isShowLanguage() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.SHOW_LANGUAGE)
    return status
}


// Show Config Screen
func setIsShowConfirmPrivacyScreen(isShow: Bool) {
    setDataToPreference(data: isShow as AnyObject, forKey: Preference.sharedInstance.SHOW_CONFIRM_PRIVACY_SCREEN)
}

func isShowConfirmPrivacyScreen() -> Bool {
    let isAccepted = getDataFromPreference(key: Preference.sharedInstance.SHOW_CONFIRM_PRIVACY_SCREEN)
    return isAccepted == nil ? false : (isAccepted as! Bool)
}


// Show Intro Screen

func setIsDarkMode(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.SHOW_DARKMODE)
}

func isShowDarkMode() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.SHOW_DARKMODE)
    return status
}


// Show Rate Us Screen

func setIsRateUS(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.SHOW_RATE_US)
}

func isShowRateUs() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.SHOW_RATE_US)
    return status
}


// Auto Import Images

func setIsAutoImportImages(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.IMPORT_IMAGES)
}

func isShowAutoImportImages() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.IMPORT_IMAGES)
    return status
}

// Auto Import Images

func setIsAutoImportVideos(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.IMPORT_VIDEOS)
}

func isShowAutoImportVideos() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.IMPORT_VIDEOS)
    return status
}

// Intro Screen

func setIsIntroOne(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.INTRO_ONE)
}

func isShowIntroOne() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.INTRO_ONE)
    return status
}

func setIsIntroTwo(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.INTRO_TWO)
}

func isShowIntroTwo() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.INTRO_TWO)
    return status
}


func setIsIntroThree(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.INTRO_THREE)
}

func isShowIntroThree() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.INTRO_THREE)
    return status
}

func setIsFirstTime(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.FIRST_TIME)
}

func isShowFirstTime() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.FIRST_TIME)
    return status
}


//MARK: Rate Pop up

func setRateFirstTime(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.FIRSTE_TIME_RATE)
}

func isShowRateFirstTime() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.FIRSTE_TIME_RATE)
    return status
}

func setRateSecondTime(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.SECOND_TIME_RATE)
}

func isShowRateSecondTime() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.SECOND_TIME_RATE)
    return status
}

func setTransferRate(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.SHOW_TRANSFER_RATE)
}

func isShowTransferRate() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.SHOW_TRANSFER_RATE)
    return status
}

func setRateDone(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.RATE_DONE)
}

func isShowRateDone() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.RATE_DONE)
    return status
}

func setComeFromItemPicker(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.COME_FROM_ITEM_PICKER)
}

func isShowComeFromItemPicker() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.COME_FROM_ITEM_PICKER)
    return status
}


func setCheckRate(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.CHECK_RATE)
}

func isShowCheckRate() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.CHECK_RATE)
    return status
}


func setBatteryAnimation(Url:String){
    UserDefaults().set(encodable: Url, forKey: Preference.sharedInstance.BATTERY_ANIMATION)
    UserDefaults().synchronize()
}

func getBatteryAniamtion() -> String{
    if let count = UserDefaults().get(String.self, forKey: Preference.sharedInstance.BATTERY_ANIMATION){
        return count
    }else{
        return ""
    }
   
}

func setProfileImg(UIImage: Data){
    UserDefaults.standard.set(UIImage, forKey: Preference.sharedInstance.PROFILE_IMG)
}

func getProfileImg() -> UIImage? {
    let code = UserDefaults.standard.data(forKey: Preference.sharedInstance.PROFILE_IMG) //as? UIImage
    return UIImage(data: code!)
    
}

func setEmailId(id:String){
    UserDefaults().set(encodable: id, forKey: Preference.sharedInstance.EMAILID)
    UserDefaults().synchronize()
}

func getEmailId() -> String{
    if let count = UserDefaults().get(String.self, forKey: Preference.sharedInstance.EMAILID){
        return count
    }else{
        return ""
    }
   
}

func setNickName(name:String){
    UserDefaults().set(encodable: name, forKey: Preference.sharedInstance.NICKNAME)
    UserDefaults().synchronize()
}

func getNickName() -> String{
    if let count = UserDefaults().get(String.self, forKey: Preference.sharedInstance.NICKNAME){
        return count
    }else{
        return ""
    }
   
}

func setGender(gender:String){
    UserDefaults().set(encodable: gender, forKey: Preference.sharedInstance.GENDER)
    UserDefaults().synchronize()
}

func getGender() -> String{
    if let count = UserDefaults().get(String.self, forKey: Preference.sharedInstance.GENDER){
        return count
    }else{
        return ""
    }
   
}

func setAge(age:String){
    UserDefaults().set(encodable: age, forKey: Preference.sharedInstance.AGE)
    UserDefaults().synchronize()
}

func getAge() -> String{
    if let count = UserDefaults().get(String.self, forKey: Preference.sharedInstance.AGE){
        return count
    }else{
        return ""
    }
   
}

func setName(name:String){
    UserDefaults().set(encodable: name, forKey: Preference.sharedInstance.NAME)
    UserDefaults().synchronize()
}

func getName() -> String{
    if let count = UserDefaults().get(String.self, forKey: Preference.sharedInstance.NAME){
        return count
    }else{
        return ""
    }
   
}

func setIsAppTerminate(status:Bool){
    UserDefaults.standard.set(status, forKey: Preference.sharedInstance.APP_TERMINATE)
}

func getAppTerminate() -> Bool{
    let status = UserDefaults.standard.bool(forKey: Preference.sharedInstance.APP_TERMINATE)
    return status
}
