//
//  ViewController.swift
//  RealmSample
//
//  Created by blesssecret on 11/11/16.
//  Copyright © 2016 usc. All rights reserved.
//

import UIKit
import RealmSwift

class Person: Object {
    dynamic var firstname = ""
    dynamic var lastname = ""
}
class ViewController: UIViewController {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    //right navi button
    var buttonAdd : UIBarButtonItem!
    //tableview
    var tableViewData : UITableView!
    let cellGeneral = "cellGeneral"
    //add and modify view
    var viewBackground : UIView!
    var viewAddModify : UIView!
    var buttonBackground : UIButton!
    var labelTitle : UILabel!
    var textFirst : UITextField!
    var textLast : UITextField!
    var buttonSave : UIButton!
    //Realm
    let realm = try!Realm()
    var arrPerson : Results<Person>!
    var globalIndex : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        addFunction()
        initialAddView()
        initialTableView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrPerson = try!Realm().objects(Person)
    }
    func addFunction() {
        buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addRow))
        self.navigationItem.rightBarButtonItem = buttonAdd
    }
    func initialAddView(){
        viewBackground = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        viewBackground.backgroundColor = UIColor(colorLiteralRed: 107/255, green: 105/255, blue: 105/255, alpha: 0.5)
        //self.view.addSubview(viewBackground)

        buttonBackground = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        buttonBackground.addTarget(self, action: #selector(self.removeAddView), for: .touchUpInside)
        viewBackground.addSubview(buttonBackground)

        viewAddModify = UIView(frame: CGRect(x: 0,y: 100,width: 268,height: 280))
        viewAddModify.center.x = screenWidth / 2
        viewAddModify.backgroundColor = UIColor.white
        viewAddModify.layer.cornerRadius = 21
        self.viewBackground.addSubview(viewAddModify)

        labelTitle = UILabel(frame: CGRect(x: 0, y: 24, width: 228, height: 54))
        labelTitle.center.x = 268 / 2
        labelTitle.text = "Input you firstname and lastname!"
        labelTitle.textColor = getColor(red: 107, green: 105, blue: 105)
        labelTitle.font = UIFont(name: "AvenirNext-Medium", size: 20)
        labelTitle.numberOfLines = 0
        labelTitle.sizeToFit()
        viewAddModify.addSubview(labelTitle)

        textFirst = UITextField(frame: CGRect(x: 0, y: 102, width: 228, height: 30))
        textFirst.center.x = 268 / 2
        textFirst.placeholder = "First name"
        textFirst.textColor = getColor(red: 89, green: 89, blue: 89)
        viewAddModify.addSubview(textFirst)

        textLast = UITextField(frame: CGRect(x: 0, y: 156, width: 228, height: 30))
        textLast.center.x = 268 / 2
        textLast.placeholder = "First name"
        textLast.textColor = getColor(red: 89, green: 89, blue: 89)
        viewAddModify.addSubview(textLast)

        buttonSave = UIButton(frame: CGRect(x: 0, y: 210, width: 228, height: 50))
        buttonSave.center.x = 268 / 2
        buttonSave.layer.cornerRadius = 50 / 2
        buttonSave.backgroundColor = getColor(red: 249, green: 90, blue: 90)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.addTarget(self, action: #selector(ViewController.saveObject(sender:)), for: .touchUpInside)
        viewAddModify.addSubview(buttonSave)
    }
    func saveObject(sender: UIButton) {
        self.removeAddView()
        if (textFirst.text?.characters.count)! > 0 && (textLast.text?.characters.count)! > 0 {
            if sender.tag == 0 {
                let newPerson = Person()
                newPerson.firstname = textFirst.text!
                newPerson.lastname = textLast.text!
                try!realm.write {
                    realm.add(newPerson)
                }
            } else {
                let per = arrPerson[globalIndex]
                try!realm.write {
                    per.firstname = textFirst.text!
                    per.lastname = textLast.text!
                }
            }
            textFirst.text = ""
            textLast.text = ""
            self.tableViewData.reloadData()

        } else {
            let alert = UIAlertController(title: "Alert", message: "Please input First name and Last name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func updateAtIndex(index: Int) {
        //print("update :" + String(index))
        buttonSave.tag = 1
        globalIndex = index
        self.view.addSubview(viewBackground)
    }
    func deleteAtIndex(index: Int) {
        //print("delete :" + String(index))
        let per = arrPerson[index]
        try! realm.write {
            realm.delete(per)
            self.tableViewData.reloadData()
        }
        print(arrPerson)
    }
    func removeAddView() {
        self.viewBackground.removeFromSuperview()
    }
    func addRow() {
        buttonSave.tag = 0
        self.view.addSubview(viewBackground)
    }
    func getColor(red: Float, green: Float, blue: Float) -> UIColor {
        return UIColor(colorLiteralRed: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    func testRealm() {
        //print(Realm.Configuration())
        let realm = try!Realm()

        let newPerson = Person()
        newPerson.firstname = "wenye3"
        newPerson.lastname = "yu"
        /*
         try!realm.write {
         realm.add(newPerson)
         }*/
        let per = try!Realm().objects(Person)

        print(per)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func initialTableView() {
        tableViewData = UITableView(frame: CGRect(x:0, y:0, width: screenWidth, height: screenHeight), style: .plain)
        tableViewData.register(UINib(nibName: "ModifyTableViewCell",bundle: nil), forCellReuseIdentifier: cellGeneral)
        tableViewData.backgroundColor = UIColor.white
        tableViewData.delegate = self
        tableViewData.dataSource = self
        tableViewData.rowHeight = 60
        self.view.addSubview(tableViewData)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(arrPerson)
        return arrPerson.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellGeneral, for: indexPath) as! ModifyTableViewCell
        let per = arrPerson[indexPath.row]
        cell.labelTitle.text = per.firstname + ", " + per.lastname
        cell.index = indexPath.row
        cell.preview = self
        return cell
    }


}
