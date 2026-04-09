//
//  PremiumVC.swift
//  Football
//
//  Created by Parthiv Akbari on 08/12/25.
//

import UIKit
import StoreKit
import SafariServices
import SVProgressHUD

enum Products: String, CaseIterable {
    case porno_yearly = "YearlyFoot"
    case porno_monthly = "MonthlyFoot"
}

class PremiumVC: UIViewController, SKProductsRequestDelegate {

    @IBOutlet weak var plansCollectionView: UICollectionView! {
       didSet {
           self.plansCollectionView.register(UINib(nibName: "PremiumCell", bundle: nil), forCellWithReuseIdentifier: "PremiumCell")
       }
   }
   
   var models = [SKProduct]()
   var selectedIndex: Int = 0
   var superVC : UIViewController!
   
   override func viewDidLoad() {
       super.viewDidLoad()
       logAnalyticAction(title: "", status: AnalyticEvent.Premium)
       SKPaymentQueue.default().add(self)
       fetchInAppProduct()
   }
   
   private func fetchInAppProduct() {
       let request  = SKProductsRequest(productIdentifiers: Set(Products.allCases.compactMap({$0.rawValue})))
       request.delegate = self
       request.start()
       SVProgressHUD.dismiss()
   }
   
   func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
       DispatchQueue.main.async {
           print("Count:\(response.products)")
           self.models = response.products
           self.models.sort { $0.price.doubleValue > $1.price.doubleValue }
           WebServices().ProgressViewHide(uiView: self.view)
           self.plansCollectionView.reloadData()
       }
   }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        if let svc = self.superVC as? HomeVC {
            dismiss(animated: true) {
                svc.showRateScreen()
            }
        }else{
            dismiss(animated: true)
        }
    }
    
    @IBAction func restoreTapped(_ sender: UIButton) {
        SVProgressHUD.show()
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        SVProgressHUD.dismiss()
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments() {
            if models.count > 0 {
                SVProgressHUD.show()
                let payment = SKPayment(product: models[selectedIndex])
                SKPaymentQueue.default().add(payment)
            }
        }
        self.plansCollectionView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    @IBAction func termsTapped(_ sender: UIButton) {
        logAnalyticAction(title: "", status: AnalyticEvent.Terms)
        if let url = URL(string: "\(TERM_AND_CONDITION)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func privacyTapped(_ sender: UIButton) {
        logAnalyticAction(title: "", status: AnalyticEvent.Privacy)
        if let url = URL(string: "\(PRIVACY_POLICY)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func eulaTapped(_ sender: UIButton) {
        logAnalyticAction(title: "", status: AnalyticEvent.Eula)
        if let url = URL(string: "\(EULA)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

extension PremiumVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.models.count < 1 {
            self.plansCollectionView.isHidden = true
            return 0
        } else {
            self.plansCollectionView.isHidden = false
            return models.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PremiumCell", for: indexPath) as! PremiumCell
        let plan = models[indexPath.item]
        
        
        if indexPath.item == 0 {
            cell.bestOfferImg.isHidden = false
            cell.durationLbl.text = "Yearly"
            cell.priceLbl.text = "\(plan.priceLocale.currencySymbol!)\(plan.price)/year"
        } else {
            cell.bestOfferImg.isHidden = true
            cell.durationLbl.text = "Monthly"
            cell.priceLbl.text = "\(plan.priceLocale.currencySymbol!)\(plan.price)/month"
        }
        
        if indexPath.item == self.selectedIndex {
            cell.bgImg.image = UIImage(named: "SelectedPlanBG")
            cell.checkImg.image = UIImage(systemName: "circle.inset.filled")
            cell.checkImg.tintColor = .black
            cell.durationLbl.textColor = .black
            cell.priceLbl.textColor = .black
        } else {
            cell.bgImg.image = UIImage(named: "UnSelectedPlanBG")
            cell.checkImg.image = UIImage(systemName: "circle")
            cell.checkImg.tintColor = .white
            cell.durationLbl.textColor = .white
            cell.priceLbl.textColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        self.plansCollectionView.reloadData()
         
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width), height: 92)
    }
    
    
}

//MARK: - SKPaymentTransactionObserver
extension PremiumVC : SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //imp
        
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                
                SKPaymentQueue.default().finishTransaction($0)
                
                setIsUserSubscribe(isSubscribe: true)
                WebServices().ProgressViewHide(uiView: self.view)
                UserDefaults.standard.synchronize()
                if let svc = self.superVC as? HomeVC {
                    dismiss(animated: true) {
                        svc.showRateScreen()
                    }
                }else{
                    dismiss(animated: true)
                }
                
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction($0)
                WebServices().ProgressViewHide(uiView: self.view)
                showAlertMsg(Message: "faild your transection please try again !!!", AutoHide: false)
                
                
                let failed = UIAlertController(title: "Purchase Stopped", message: "Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance.", preferredStyle: .alert)
                failed.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    if let svc = self.superVC as? HomeVC {
                        self.dismiss(animated: true) {
                            svc.showRateScreen()
                        }
                    }else{
                        self.dismiss(animated: true)
                    }
                }))
                
                self.present(failed, animated: true, completion: nil)
                
            case .restored:
                print("restored")
                
                WebServices().ProgressViewHide(uiView: self.view)
                setIsUserSubscribe(isSubscribe: true)
                UserDefaults.standard.synchronize()
                
            case .deferred:
                break
            @unknown default:
                break
            }
        })
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // Restore completed transactions failed
        // You can handle any necessary error handling or display an error message to the user
        print("Restore completed transactions failed with error: \(error.localizedDescription)")
        let restore = UIAlertController(title: "No Subscription to Restore", message: "You don't have an active subscription.", preferredStyle: .alert)
        restore.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(restore, animated: true, completion: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        // Restore completed transactions finished successfully
        // You can handle any necessary logic here, such as updating UI or displaying a success message
        print("Restore completed transactions finished successfully")
        for transaction in queue.transactions {
            if (transaction.original?.payment.productIdentifier) != nil {
                // Restore the productIdentifier and mark the subscription as active
                setIsUserSubscribe(isSubscribe: true)
                UserDefaults.standard.synchronize()
                let restore = UIAlertController(title: "Restore", message: "Subscription Restored Successfully!", preferredStyle: .alert)
                restore.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.dismiss(animated: false)
                }))
                
                self.present(restore, animated: true, completion: nil)
            } else {
                let restore = UIAlertController(title: "No Subscription to Restore", message: "You don't have an active subscription.", preferredStyle: .alert)
                restore.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(restore, animated: true, completion: nil)
            }
        }
        
        if queue.transactions.isEmpty == true {
            let restore = UIAlertController(title: "No Subscription to Restore", message: "You don't have an active subscription.", preferredStyle: .alert)
            restore.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(restore, animated: true, completion: nil)
        }
    }
}
