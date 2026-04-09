//
//  GlobalConstant.swift
//  CastToTV
//
//  Created by 7SEASOL-2 on 17/07/24.
//

import Foundation
import UIKit

var finalURL = ""


func createFolderInDocumentDirectory(folderName: String) {
    let fileManager = FileManager.default
    guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        // Failed to retrieve the document directory
        return
    }
    
    let folderURL = documentDirectory.appendingPathComponent(folderName)
    
    if fileManager.fileExists(atPath: folderURL.path) {
        // Folder already exists, no need to create it
        print("Folder already exists at path: \(folderURL.path)")
        return
    }
    
    do {
        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        print("Folder created successfully at path: \(folderURL.path)")
    } catch {
        print("Error creating folder: \(error.localizedDescription)")
    }
}

func createCustomFolder(folderName: String) -> URL? {
    let fileManager = FileManager.default
    guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    let customFolderURL = documentsURL.appendingPathComponent(folderName)
    
    if !fileManager.fileExists(atPath: customFolderURL.path) {
        do {
            try fileManager.createDirectory(at: customFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating folder: \(error.localizedDescription)")
            return nil
        }
    }
    
    return customFolderURL
}


func fetchURLsFromFolder(folderName: String) -> [URL]? {
    let fileManager = FileManager.default
    let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let folderURL = documentDirectory.appendingPathComponent(folderName)

    do {
        let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return fileURLs
    } catch {
        print("Error while fetching URLs from folder: \(error.localizedDescription)")
        return nil
    }
}

func saveImageToCustomFolder(image: UIImage, folderName: String, fileName: String) {
    guard let customFolderURL = createCustomFolder(folderName: folderName) else {
        print("Failed to create or access custom folder.")
        return
    }
    
    let fileURL = customFolderURL.appendingPathComponent(fileName)
    
    guard let imageData = convertImageToData(image: image) else {
        print("Failed to convert image to data.")
        return
    }
    
    do {
        try imageData.write(to: fileURL)
        print("Image saved successfully to \(fileURL.path)")
    } catch {
        print("Error saving image: \(error.localizedDescription)")
    }
}

func convertImageToData(image: UIImage) -> Data? {
    return image.jpegData(compressionQuality: 1.0) // or use pngData() for PNG format
}


func saveImageToTempFolder(image: UIImage, fileName: String) -> URL? {
    // 1. Convert the UIImage to Data
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
        print("Failed to convert image to data")
        return nil
    }
    
    // 2. Get the path to the temp folder
    let fileManager = FileManager.default
    let tempDirectoryURL = fileManager.temporaryDirectory

    // 3. Create the temp folder in the Document Directory if it doesn't exist
    let tempFolderURL = tempDirectoryURL.appendingPathComponent("Temp")
    if !fileManager.fileExists(atPath: tempFolderURL.path) {
        do {
            try fileManager.createDirectory(at: tempFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create temp directory: \(error)")
            return nil
        }
    }

    // 4. Define the file path in the temp folder
    let fileURL = tempFolderURL.appendingPathComponent(fileName)

    // 5. Save the Data object to the file
    do {
        try imageData.write(to: fileURL)
        print("Image successfully saved to \(fileURL.path)")
        return fileURL
    } catch {
        print("Failed to save image: \(error)")
        return nil
    }
}

func convertTimestamp(_ timestamp: Int) -> (formattedDate: String, formattedTime: String, formattedDifference: String) {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    
    // Format the Date to "Saturday, 22 Jun"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, dd MMM"
    let formattedDate = dateFormatter.string(from: date)
    
    // Format the Date to "05:30AM"
    dateFormatter.dateFormat = "hh:mma"
    let formattedTime = dateFormatter.string(from: date)
    
    // Calculate the time difference from the current date and time
    let currentDate = Date()
    let difference = date.timeIntervalSince(currentDate)
    let differenceHours = Int(difference) / 3600
    let differenceMinutes = (Int(difference) % 3600) / 60
    
    let formattedDifference = String(format: "%02d:%02d", differenceHours, differenceMinutes)
    
    return (formattedDate, formattedTime, formattedDifference)
}
