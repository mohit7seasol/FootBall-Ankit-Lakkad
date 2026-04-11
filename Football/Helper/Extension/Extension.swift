//
//  Extension.swift
//  Train
//
//  Created by 7SEASOL-2 on 12/12/23.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

extension UIViewController {
    
    func dismissAndPopAllViewViewControllers() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
            (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
        }
    }
    
    
    class public var storyboardID: String
    {
        return "\(self)"
    }

    static public func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self
    {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
}


public enum AppStoryboard: String
{
    
    case Main
    
    public var instance: UIStoryboard
    {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    public func viewController<T: UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T
    {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else
        {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    public func initialViewController() -> UIViewController?
    {
        return instance.instantiateInitialViewController()
    }
}

/*func showPermissionAlert(title: String, msg: String) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Open Setting", style: UIAlertAction.Style.default, handler: { (ACTION) in
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
            assertionFailure("Not able to open App privacy settings")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }))
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
}*/

extension String {
    func firstMatch(of pattern: String) -> Range<String.Index>? {
        if let range = self.range(of: pattern, options: .regularExpression) {
            return Range(uncheckedBounds: (lower: range.lowerBound, upper: range.upperBound))
        }
        return nil
    }
}


extension UIView {
    public func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    // MARK: - ClickListener
    class ClickListener: UITapGestureRecognizer {
        var onClick : (() -> Void)? = nil
    }
    
    func setOnClickListener(action :@escaping () -> Void){
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        self.addGestureRecognizer(tapRecogniser)
    }
    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath

        layer.mask = maskLayer
    }
}

extension Date {
    
    func timestamp() -> Int {
        return Int(Date().timeIntervalSince1970 * 10000000)
    }
    
    func timestampToDate(timeStamp: Float) -> Date {
        let epocTime = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: epocTime)
        return date as Date
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour,  from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calender = Calendar.current
        var components = calender.dateComponents(x, from: self)
        
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return calender.date(from: components)
    }
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var weekNumber: Int {
        let calendar = NSCalendar.current
        let component = calendar.component(.weekOfYear, from: self)
        return component
    }
    
    var TolocalDate: Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else { return Date() }
        return localDate
    }
    
    func addDays(toDate: Date = Date(), addDay: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: addDay, to: toDate) ?? Date()
    }
}

extension URL {
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    // Check Media Type
    func mimeType() -> String {
         let pathExtension = self.pathExtension
         if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
             if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
             }
         }
         return "application/octet-stream"
    }

    var containsImage: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
             return false
        }
        return UTTypeConformsTo(uti, kUTTypeImage)
    }

    var containsAudio: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
              return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }
    var containsVideo: Bool {
        let mimeType = self.mimeType()
        guard  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
               return false
        }
        return UTTypeConformsTo(uti, kUTTypeMovie)
    }
    
}


// MARK: - String Extentions -
extension String {
    
    public func length() -> Int {
        return self.lengthOfBytes(using: String.Encoding.utf8)
    }
    
    func sizeOfString(width: CGFloat, font : UIFont) -> CGSize {
        return NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    
    func removeWord(str: String) -> String {
        var string = self
        if let range = self.range(of: str) {
            string.removeSubrange(range)
        }
        
        return string
    }
    
    var removeExcessiveSpaces: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespaces)
        let filtered = components.filter({!$0.isEmpty})
        return filtered.joined(separator: " ")
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidUrl: Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var encoded: String {
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let data: Data? = str.data(using: String.Encoding.nonLossyASCII)
        let Value = String(data: data!, encoding: String.Encoding.utf8)
        return Value ?? ""
    }
    
    var urlEncoded: String {
        let data: Data? = self.data(using: String.Encoding.nonLossyASCII)
        let Value = String(data: data!, encoding: String.Encoding.utf8)
        return Value ?? ""
    }
    
    var decoded: String {
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let data: Data? = str.data(using: String.Encoding.utf8)
        let Value = String(data: data!, encoding: String.Encoding.nonLossyASCII)
        return Value ?? ""
    }
    
    var toValidUrl: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var toData: Data {
        return Data(self.utf8)
    }
    
    var toJson: [String: Any] {
        let data = self.toData
        if let json = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
            return json
        } else {
            return [String: Any]()
        }
    }
    
    func toDate(_ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}


// MARK: - PHAsset -
extension PHAsset {
    
    var fileName: String? {
        let resource = PHAssetResource.assetResources(for: self)
        return resource.first?.originalFilename
    }
    
    var fileSize: String {
        let resource = PHAssetResource.assetResources(for: self)
        let unsignedInt64 = resource.first?.value(forKey: "fileSize") as? CLong ?? 0
        let sizeOnDisk: Int64 = Int64(bitPattern: UInt64(unsignedInt64))
        let fileSizeString = String(format: "%.2f", Double(sizeOnDisk) / (1024.0 * 1024.0)) + " MB"
        return fileSizeString
    }
    
    var fileCreatedDate: Date {
        return self.creationDate ?? Date()
    }
}


extension UIViewController {
    func showInterAd() {
        if isUserSubscribe() == false {
            adsPlus = adsPlus+1
            if adsPlus % afterClick == 0
            {
                AdsManager.shared.presentInterstitialAd1(vc: self)
            }
        }
    }
    
    
    func showInterAdSession() {
        DispatchQueue.main.async{
            if isUserSubscribe() == false {
                AdsManager.shared.presentInterstitialAd1(vc: self)
            }
        }
        
    }
    
}

extension UIButton {
    func underlineText() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
