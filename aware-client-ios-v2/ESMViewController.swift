//
//  ESMViewController.swift
//  aware-client-ios-v2
//
//  Created by Yuuki Nishiyama on 2019/02/27.
//  Copyright © 2019 Yuuki Nishiyama. All rights reserved.
//

import UIKit
import AWAREFramework
import WebKit

class ESMViewController: UIViewController {

    @IBOutlet weak var surveyButton: UIButton!
    @IBOutlet weak var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if OnboardingManager.isFirstTime() {
//            OnboardingManager().startOnboarding(with: self)
//        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.checkESMSchedules()
        self.hideContextViewIfNeeded()
        // AWARECore.shared().checkCompliance(with: self)
        
        let study = AWAREStudy.shared();
      
        if OnboardingManager.isFirstTime() {
        let alert = UIAlertController(title: "מזהה משתמש במחקר", message: "", preferredStyle: UIAlertController.Style.alert)
              
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                  textField.placeholder = "הכנס מזהה"
        })
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0].text // Force unwrapping because we know it exists.
                print(textField!);
                study.setDeviceName(textField!);
                study.refreshStudySettings();
                OnboardingManager().startOnboarding(with: self);
        }));
      self.present(alert, animated: true, completion: nil)
          }
        
        let url = URL(string: "http://bigdatalab.eng.tau.ac.il/permed/q_app/?id=" + study.getDeviceId());
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForegroundNotification(notification: NSNotification) {
        self.checkESMSchedules()
    }
    
    func checkESMSchedules(){
        self.tabBarController?.tabBar.isHidden = false
        let esmManager = ESMScheduleManager.shared()
        let schedules = esmManager.getValidSchedules()
        
        if(schedules.count > 0){
            surveyButton.setTitle(NSLocalizedString("Tap to answer survey(s)", comment: ""),
                                  for: .normal)
            surveyButton.layer.borderColor = UIColor.system.cgColor
            surveyButton.layer.borderWidth  = 2
            surveyButton.layer.cornerRadius = 5
            surveyButton.isEnabled = true
        } else {
            surveyButton.isEnabled = false
            surveyButton.setTitle(NSLocalizedString("No pending survey(s)", comment: ""),
                                  for: .normal)
            surveyButton.layer.borderColor = UIColor(white: 0, alpha: 0).cgColor
        }
        
        IOSESM.setESMAppearedState(true)
    }
    
    @IBAction func didPushSurveyButton(_ sender: UIButton) {
        let esmManager = ESMScheduleManager.shared()
        let schedules = esmManager.getValidSchedules()
        if( schedules.count > 0){
            self.performSegue(withIdentifier: "toESMScrollView", sender: self)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
//        if let next = segue.destination as? ESMScrollViewController{
//            next.tabBarController?.tabBar.isHidden = true
//        }
//        self.tabBarController?.tabBar.isHidden = true
        
    }

}

extension UIColor {
    static let system = UIView().tintColor!
}

extension IOSESM {
    
}
