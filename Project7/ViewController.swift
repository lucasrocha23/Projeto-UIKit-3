//
//  ViewController.swift
//  Project7
//
//  Created by Lucas Rocha on 16/09/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var showedPetitions = [Petition]()
    var urlString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        
        //let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        let credits = UIBarButtonItem(title: "credits", style: .plain , target: self, action: #selector(credits))
        
        let filter = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filtering) )
        
        navigationItem.rightBarButtonItems = [filter, credits]
        
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON(){
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
   
    }
    
    
    @objc func filtering(){
        let aletController = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        aletController.addTextField()
        aletController.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak aletController] action in
            guard let userInput = aletController?.textFields?[0].text else {return}
            self?.submit(userInput)
        }
        
        aletController.addAction(submitAction)
        present(aletController, animated: true)
    }
    
    func submit(_ userInput: String){
        let lowerInput = userInput.lowercased()
        var filtered = [Petition]()
        
        var searchFinded = 0
        for petition in petitions  {
            if (petition.title.lowercased().contains(lowerInput) || petition.body.lowercased().contains(lowerInput)){
                filtered.append(petition)
                searchFinded += 1
            }
        }
        if searchFinded == 0{
            let alertController = UIAlertController(title: "Not found", message: "The text you typed was not found in any petition", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController,animated: true)
            return
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearFilter))
        
        showedPetitions.removeAll(keepingCapacity: true)
        showedPetitions = filtered
        tableView.reloadData()
    }
    
    @objc func clearFilter(){
        let ac = UIAlertController (title: "Clear Search?", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: confirmedClear))
        present(ac, animated: true)
        
    }
    
    func confirmedClear(_ action: UIAlertAction! = nil){
        showedPetitions.removeAll(keepingCapacity: true)
        navigationItem.leftBarButtonItem = nil
        showedPetitions = petitions
        tableView.reloadData()
    }
    
    @objc func credits(){
        let alertController = UIAlertController(title: "Credits", message: "All the data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController,animated: true)
    }
    
    @objc func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac,animated: true)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            showedPetitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        } else{
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showedPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = showedPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = showedPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

 
