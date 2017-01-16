//
//  ViewController.swift
//  FormTableView
//
//  Created by xuech on 2016/12/30.
//  Copyright © 2016年 obizsoft. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {
    
    var nameRow : NameRow?
    var nikeNameRow : NameRow?
    var emailRow : EmailRow?
    var sexRow : AlertRow<Sex>?
    var positionRow :PushRow<String>?
    var sizeRow : AlertRow<Size>?
    var birthRow : DateInlineRow?
    var switchRow : SwitchRow?
    var campusRow: AlertRow<String>?

    typealias Sex = String
    let 👦🏼 = "👦🏼", 💁🏻 = "💁🏻"

    typealias Size = String
    let S = "S", M = "M", L = "L",X = "X", XL = "XL", XX = "XX"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "注册"
        
        setupForm()
    }
    
    private func setupForm() {
        NameRow.defaultCellUpdate = { cell, row in cell.textField.textColor = .orange  }
        AlertRow<String>.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .orange }
        DateInlineRow.defaultRowInitializer = { row in row.maximumDate = Date() }
        PushRow<String>.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .orange }
        form =  Section(){ section in
            section.header = {
                var header = HeaderFooterView<UIView>(.callback({
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    return view
                }))
                header.height = { 1 }
                return header
            }()
            
            section.footer = {
                var footer = HeaderFooterView<UIView>(.callback({
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    return view
                }))
                footer.height = { 1 }
                return footer
            }()
        }
            +++ Section("姓名")
            <<< NameRow("passportName"){ row in
                row.title = "真实姓名"
                row.placeholder = "请输入真实姓名"
                row.add(rule: RuleRequired())
                row.cellUpdate{ cell, se in
                    self.nameRow = row
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
        }
            <<< NameRow("nikeName"){ row in
                row.title = "昵称"
                row.placeholder = "请输入昵称"
                row.add(rule: RuleRequired())
                row.cellUpdate{ cell, se in
                    self.nikeNameRow = row
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
        }
        +++ Section("基本信息")
            <<< AlertRow<Sex>("sex") { row in
                row.title = "性别"
                row.selectorTitle = "性别"
                row.options = [💁🏻,👦🏼]
                row.value = 👦🏼
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .orange
        }
            <<< PushRow<String>("position") {
                $0.title =  "场上位置"
                $0.add(rule: RuleRequired())
                $0.options = ["中锋","前锋","守门员"]
                $0.value = "中锋"
                $0.selectorTitle = "Choose an Emoji!"
        }
            <<< AlertRow<Size>("size") {
                $0.title = "球衣尺寸"
                $0.add(rule: RuleRequired())
                $0.selectorTitle = "球衣尺寸"
                $0.options = [S,M,L,X,XL,XX]
                $0.value = L
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .blue
        }
            <<< EmailRow("email"){ row in
                row.title = "邮箱"
                row.placeholder = "请输入邮箱地址"
                row.add(rule: RuleRequired())
                row.add(rule: RuleEmail())
                row.cellUpdate{ cell, se in
                    self.emailRow = row
                    if !row.isValid{
                        cell.titleLabel?.textColor = .red
                    }
                }
        }
            <<< DateInlineRow("birthDay") { row in
                row.title = "出生日期"
                row.add(rule: RuleRequired())
        }
            <<< SwitchRow("userType"){ row in
                row.title = "社会/青少年"
        }
            <<< AlertRow<String>("Campus"){ row in
                row.title = "请选择角色"
                row.options = ["教练","领队"]
                row.hidden = .function(["userType"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "userType")
                    return row.value ?? false == false
                })
        }
        
        +++ Section()
            <<< ButtonRow() {
                $0.title = "Submit"
                $0.onCellSelection({ (cell, row) in
                    self.submitForm()
                }).cellSetup { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.backgroundColor = UIColor.orange
                }
        }
    }
    
    func submitForm() {
        let isValid = self.valid()
        if isValid {
            let valuesDictionary = form.values()
            print("valuesDictionary\n \(valuesDictionary)")
        }

    }
    
    func valid() -> Bool{
        var isValid = true
        if nameRow?.value == nil || (nameRow?.value  != nil && !nameRow!.isValid) {
            nameRow?.cell?.titleLabel?.textColor = .red
            isValid = false
        }
        if nikeNameRow?.value == nil || (nikeNameRow?.value  != nil && !nikeNameRow!.isValid) {
            nikeNameRow?.cell?.titleLabel?.textColor = .red
            isValid = false
        }
        if emailRow?.value == nil || (emailRow?.value  != nil && !emailRow!.isValid) {
            emailRow?.cell?.titleLabel?.textColor = .red
            isValid = false
        }
        return isValid
    }





}

