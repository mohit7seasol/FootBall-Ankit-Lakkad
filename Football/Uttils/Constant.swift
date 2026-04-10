//
//  Constant.swift
//  QuickShare
//
//  Created by 7SEASOL-2 on 08/05/24.
//

import Foundation
import UIKit
import Toaster
import Photos
import MobileCoreServices
import AVFoundation
import AVKit
import MediaPlayer

let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
var StoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
let MAIL = "ankitlakkad009@gmail.com"
let APP_NAME = "FootUltras"
let AppID = "6743467577"
let AppLink = "https://itunes.apple.com/app/id\(AppID)"
let REVIEW_LINK = "https://apps.apple.com/app/id\(AppID)?action=write-review"
let SHARE_ID = "https://itunes.apple.com/app/id\(AppID)"
let PRIVACY_POLICY = "https://file-exchanger-plus.netlify.app/"
let TERM_AND_CONDITION = "https://vsapps7.blogspot.com/2024/10/termicrickmaster.html"
let EULA = "https://media-lamps.netlify.app/eula"
let AppStoreLink = "https://apps.apple.com/app/id\(AppID)"
let SHARE_SECRET = ""
var FromGetStarted = false

let ACCESS = "AKIA2FCATE7MLGSZBHML"
let SECRET = "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"

let baseURL = "https://02ee-2405-201-202e-b004-48bb-a9ba-2f05-6677.ngrok-free.app/i/?url="

//live json
let getJSON : String = "https://7seasol-application.s3.amazonaws.com/admin_prod/pbz-hygenf-sbbg.json"

//test json
//let getJSON : String = "https://7seasol-application.s3.amazonaws.com/admin_prod/grfg.json"


var APITOKEN = "1831bcfd61mshe49ae7779397e4fp16532cjsncaf029ae4ce0"

var bannerId = ""
var nativeId = ""
var nativeId2 = ""
var interstialId = ""
var interstialId2 = ""
var appopenId = ""
var rewardId = ""
var sec_bannerId = ""
var sec_nativeId = ""
var sec_interstialId = ""
var sec_rewardId = ""
var sec_appopenId = ""
var addButtonColor = ""
var adsCount = 0
var adsPlus = 0
var isBackgound = Bool()
var isComeFromResult = false
var appOpenHome = false
var isAppStart = false
var afterClick = 0
var isComeFromSplash = false

let MESSAGE_ERR_NETWORK = "No internet connection. Try again.."
let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width

var LiveMatchAPI: String = "https://apis.sportstiger.com/Prod/get-live-matches"
var UpcomingMatchAPI: String = "https://apis.sportstiger.com/Prod/get-upcoming-matches"
var ResultMatchAPI: String = "https://apis.sportstiger.com/Prod/get-completed-matches"
var NewsAPI:String = ""
var MatchSquadAPI:String = "https://apis.sportstiger.com/Prod/match-squad"
var MatchTabAPI:String = "https://apis.sportstiger.com/Prod/get-match-tabs"
var MatchInfoAPI:String = "https://apis.sportstiger.com/Prod/match-info"
var MatchPointTableAPI:String = "https://apis.sportstiger.com/Prod/points-table"
var MatchLiveUpdateAPI:String = "https://apis.sportstiger.com/Prod/football-match-commentary"
var MatchStatsAPI:String = "https://apis.sportstiger.com/Prod/football-match-stats"
var MatchOverViewAPI:String = "https://apis.sportstiger.com/Prod/football-match-overview"
var SeriesMatchAPI: String = "https://apis.sportstiger.com/Prod/match-schedule"

var matchCat = "All"
var isComeFromUpcoming = false
