//
//  ViewController.swift
//  textFieldTest
//
//  Created by GANMENG on 2018/4/2.
//  Copyright © 2018年 感觉萌. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //最大输入限制
    let MaxNumberOfDescriptionChars = 10

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        NotificationCenter.default.addObserver(self, selector: Selector(#selector(textViewEditChanged(_:))), name: .UITextFieldTextDidChange, object: textField)

    }

   @objc func textViewEditChanged(_ obj: Notification?) {
        let textField = obj?.object as! UITextField
        let toBeString = textField.text!
        let lang = UIApplication.shared.textInputMode?.primaryLanguage
        //UITextInputMode.current()?.primaryLanguage  ios 7后被销毁
        // 键盘输入模式
        let maxLength = Int(MaxNumberOfDescriptionChars)
        //加上自动定位的地址，上限是10个汉字
        if (lang == "zh-Hans") {
            // 简体中文输入，包括简体拼音，健体五笔，简体手写
            let selectedRange: UITextRange? = textField.markedTextRange
            //获取高亮部分
            var position: UITextPosition? = nil
            if let aStart = selectedRange?.start {
                position = textField.position(from: aStart, offset: 0)
            }
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if position == nil {
                if toBeString.count > maxLength {
                    let rIndex = toBeString.index(toBeString.startIndex, offsetBy: maxLength)
                    textField.text = toBeString.prefix(upTo: rIndex)
                }
            } else {}
        } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if toBeString.length > maxLength {
                textField.text = (toBeString as? NSString)?.substring(to: maxLength)
            }        
        }
    }
    
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "") {
            return true
        }
        let toBeString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if self.textField == textField {
            let maxLength = Int(MaxNumberOfDescriptionChars)
            //设置文字上限
            if (toBeString?.count ?? 0) > maxLength {
                textField.text = toBeString.substring(to: maxLength)
                return false
            }
        }
        return true
    }

        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

