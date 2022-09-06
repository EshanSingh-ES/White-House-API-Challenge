//
//  ViewController.swift
//  Project7
//
//  Created by Eshan Singh on 26/08/22.
//

import UIKit
import WebKit

class ViewController: UITableViewController,UITextFieldDelegate{
    var petitions = [Petition]()
    var urlstring:String = ""
    var filteredItems = [Petition]()
    var inputFromAlert:String = ""
    var FilterPressed:Bool = false
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func creditsTapped(){
        let ac = UIAlertController(title: " Source of the Data ", message: "Comes from We the People API of WhiteHouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
  @objc func callFilteralert(){
        let filterAlert = UIAlertController(title: "Filter Petitions", message: "Enter Your Preference:", preferredStyle: .alert)
      filterAlert.addTextField {
            (textField) in
            textField.placeholder = "What Kind of Petitions ?"
        }
        filterAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            let fields = filterAlert.textFields
            self.inputFromAlert = fields![0].text!
            self.textFieldDidEndEditing(filterAlert.textFields![0])
        }))
        self.present(filterAlert, animated: true, completion: nil)
    
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        FilterPressed = true
        filter()
        tableView.reloadData()
    }
     func filter(){
        for i in (0 ..< petitions.count){
               let petition = petitions[i]
            if(petition.title == inputFromAlert){
                filteredItems.append(petition)
            }
            }
      // Free Raven 23
    }
    override func viewDidLoad() {
        if navigationController?.tabBarItem.tag == 0 {
          //  urlstring = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
           urlstring = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
          //  urlstring = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
           urlstring = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(callFilteralert))
        performSelector(inBackground: #selector(fetchjson), with: nil)
      
    }
   @objc func fetchjson(){
            if let url = URL(string: self.urlstring){
                if let data = try? Data(contentsOf: url){
                  parse(json: data)
                    return
                }
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            }
    }
   @objc func parse(json: Data){
            let decoder = JSONDecoder()
               if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
                   petitions = jsonPetitions.results
                   tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
               }
            }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(FilterPressed){
        return filteredItems.count
            
        }
        else{
            return petitions.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if(FilterPressed){
            let petition1 = filteredItems[0]
        cell.textLabel?.text = petition1.title
        cell.detailTextLabel?.text = petition1.body
        }
        else{
            let petition = petitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if(FilterPressed){
        vc.Detailitem = filteredItems[0]
        }
        else{
            vc.Detailitem = petitions[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

