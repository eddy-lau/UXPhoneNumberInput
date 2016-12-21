//
//  MOPhoneNumberInputViewController.swift
//  Pods
//
//  Created by Eddie Hiu-Fung Lau on 15/12/2016.
//
//

import UIKit
import PhoneNumberKit
import AJCountryPicker2

public class MOPhoneNumberInputViewController: UITableViewController {

    // MARK: - Public variables
    
    // MARK: - Public functions
    
    public func showDoneButton(withAction action: @escaping (_ phoneNumber:String)->Void) {
        doneButtonAction = action
    }
    
    // MARK: - Private variables
    @IBOutlet fileprivate weak var countryCodePlaceholder: UIView!
    @IBOutlet fileprivate weak var countryCodeField: UITextField!
    @IBOutlet fileprivate var phoneNumberPlaceholder: UIView!
    @IBOutlet fileprivate weak var phoneNumberField: UITextField!
    @IBOutlet fileprivate weak var countryNameLabel: UILabel!

    fileprivate let phoneNumberKit = PhoneNumberKit()
    
    fileprivate var selectedRegionCode: String? {
        
        guard let countryCodeText = countryCodeField.text else {
            return nil
        }
        
        guard let countryCode = UInt64(countryCodeText) else {
            return nil
        }
        return phoneNumberKit.mainCountry(forCode:countryCode)
        
    }
    
    
    // UI states
    fileprivate var shouldHideCountryCodePlaceholder: Bool {
        return (countryCodeField.text ?? "").characters.count > 0
    }
    
    fileprivate var shouldHidePhoneNumberPlaceholder: Bool {
        return (phoneNumberField.text ?? "").characters.count > 0
    }
    
    fileprivate var countryNameLabelText: String {
        
        guard let text = countryCodeField.text,!text.isEmpty else {
            return "Select From List"
        }
        
        guard
            let code = UInt64(text),
            let country = phoneNumberKit.mainCountry(forCode: code),
            let displayName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: country)
        else {
            return "Invalid country code"
        }
        
        return displayName
        
    }
    
    fileprivate var shouldEnableDoneButton: Bool {
        
        guard let countryCodeText = countryCodeField.text,
            !countryCodeText.isEmpty,
            let phoneNumberText = phoneNumberField.text,
            !phoneNumberText.isEmpty,
            let doneButtonAction = doneButtonAction
        else {
            return false
        }
        
        return true
    }
    
    fileprivate lazy var doneButtonItem: UIBarButtonItem = {
        
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(MOPhoneNumberInputViewController.didTapDoneButton))
        return item
        
    }()
    
    fileprivate var doneButtonAction: ((_ phoneNumber:String)->Void)? {
        didSet {
            if doneButtonAction != nil {
                
                navigationItem.rightBarButtonItem = doneButtonItem
                
            } else {
                
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    // MARK: - ViewController

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Your Phone Number", comment: "")
        
        countryCodeField.text = "+\(phoneNumberKit.countryCode(for:PhoneNumberKit.defaultRegionCode())!)"
        countryNameLabel.text = countryNameLabelText
        
        countryCodePlaceholder.isHidden = shouldHideCountryCodePlaceholder
        phoneNumberPlaceholder.isHidden = shouldHidePhoneNumberPlaceholder
        doneButtonItem.isEnabled = shouldEnableDoneButton
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumberField.becomeFirstResponder()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func becomeFirstResponder() -> Bool {
        return phoneNumberField.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        
        if countryCodeField.isFirstResponder {
            return countryCodeField.resignFirstResponder()
        }
        if phoneNumberField.isFirstResponder {
            return phoneNumberField.resignFirstResponder()
        }
        return super.resignFirstResponder()
        
    }
    

}

// MARK: - private functions
extension MOPhoneNumberInputViewController {
    
    func didTapDoneButton() {
        
        let countryCode = countryCodeField.text!
        let number = phoneNumberField.text!
        
        do {
            let parsedPhoneNumber = try phoneNumberKit.parse(countryCode + number)
            doneButtonAction?(phoneNumberKit.format(parsedPhoneNumber, toType: .e164))
        } catch let e as PhoneNumberError {
            
            let alertController = UIAlertController(title: "Error", message: e.description, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
            }))
            present(alertController, animated: true, completion: nil)
            
        } catch let e {
            
        }
        
        
        
    }
    
    
}

// MARK: UITableViewDelegate
extension MOPhoneNumberInputViewController {
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            let countryPicker = AJCountryPicker { country, code in
                self.countryNameLabel.text = country
                
                if let countryCode = self.phoneNumberKit.countryCode(for: code) {
                    self.countryCodeField.text = "+\(countryCode)"
                    self.navigationController?.popViewController(animated: true)
                }
            }

            //countryPicker.customCountriesCode = phoneNumberKit.allCountries()
            countryPicker.showCallingCodes = true
            
            if let countryCodeText = countryCodeField.text, let code = UInt64(countryCodeText) {
                countryPicker.selectedCountryCode = phoneNumberKit.mainCountry(forCode: code)
            }
            
            navigationController?.pushViewController(countryPicker, animated: true)
            
        }
        
    }
    
}

extension MOPhoneNumberInputViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == countryCodeField {
            
            phoneNumberField.becomeFirstResponder()
            
        } else if textField == phoneNumberField {
            
            if shouldEnableDoneButton {
                didTapDoneButton()
            }
            
        }
        return false
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == countryCodeField {
            
            // Use regex to verify the coountry code. The format likes +852
            guard let regex = try? NSRegularExpression(pattern: "^\\+[0-9]{1,4}$", options: []) else {
                return false
            }
            
            guard var text = textField.text as? NSString else {
                return false
            }
            
            var countryCode = text.replacingCharacters(in: range, with: string)
            
            if countryCode == "+" {
                
                textField.text = ""
                
            } else {
            
                if text == "" {
                    countryCode = "+" + countryCode
                }
                
                let matchCount = regex.numberOfMatches(in: countryCode, options: [], range: NSMakeRange(0, countryCode.characters.count))
                if matchCount > 0 {
                    textField.text = countryCode
                }
                
            }
            
            countryCodePlaceholder.isHidden = shouldHideCountryCodePlaceholder
            countryNameLabel.text = countryNameLabelText
            doneButtonItem.isEnabled = shouldEnableDoneButton
            return false
                
        } else if textField == phoneNumberField {
            
            guard var text = textField.text as? NSString else {
                return false
            }
            
            if !string.isEmpty {
                
                guard let regex = try? NSRegularExpression(pattern: "^[0-9]+$", options: []) else {
                    return false
                }
                guard regex.numberOfMatches(in: string, options: [], range: NSMakeRange(0, string.characters.count)) > 0 else {
                    return false
                }
                
            }
            
            var rawPhoneNumber = text.replacingCharacters(in: range, with: string)
            
            let selectedRegion = selectedRegionCode ?? PhoneNumberKit.defaultRegionCode()
            let formatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: selectedRegion, withPrefix:false)
            textField.text = formatter.formatPartial(rawPhoneNumber)
            
            phoneNumberPlaceholder.isHidden = shouldHidePhoneNumberPlaceholder
            doneButtonItem.isEnabled = shouldEnableDoneButton
            return false
            
        }
        
        return true
    }
    
}

extension MOPhoneNumberInputViewController {
    
    public static func instantiate() -> MOPhoneNumberInputViewController {
        
        let bundle = Bundle(for:self)
        
        guard let resourceBundleURL = bundle.url(forResource: "UXPhoneNumberInput", withExtension: "bundle") else {
            fatalError("Couldn't instantiate MOPhoneNumberInputViewController")
        }
        
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Couldn't instantiate MOPhoneNumberInputViewController")
        }
        
        let loginStoryboard = UIStoryboard(name: "MOPhoneNumberInputViewController", bundle: resourceBundle)
        guard let viewController = loginStoryboard.instantiateInitialViewController() as? MOPhoneNumberInputViewController else {
            fatalError("Couldn't instantiate MOPhoneNumberInputViewController")
        }
        
        return viewController
    }
    
    
}
