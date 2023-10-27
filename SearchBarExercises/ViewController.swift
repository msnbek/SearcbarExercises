//
//  ViewController.swift
//  SearchBarExercises
//
//  Created by Mahmut Senbek on 6.10.2023.
//

import UIKit
import  SnapKit

struct Person {
    var name : String
    var surname : String
    var gender : String
}

class ViewController: UIViewController {
    let tableView = UITableView()
    let searchBar = UISearchBar()
    var searched = [Person]()
    let segmentedControl = UISegmentedControl()
    var isSearching = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(segmentedControl)
        segmentedControl.insertSegment(withTitle: "Name", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Surname", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(segmentControlHandle), for: .valueChanged)
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(80)
        }
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.autocorrectionType = .no
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            
        }
        
    }
    
    @objc func segmentControlHandle() {
        if segmentedControl.selectedSegmentIndex == 0 {
            searchBar.placeholder = "Search a Name"
        }else if segmentedControl.selectedSegmentIndex == 1 {
            searchBar.placeholder = "Search a Surname"
        }
    }
    
    
}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searched.count : ViewController.persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let person: Person
        if isSearching {
            person = searched[indexPath.row]
        } else {
            person = ViewController.persons[indexPath.row]
        }
        cell.textLabel?.text = "\(person.name) \(person.surname)"
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        cell.layer.shadowOpacity = 0.9
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if segmentedControl.selectedSegmentIndex == 0 {
            filterName(searchText: searchText)
            searchBar.placeholder = "Search a Name"
        } else if segmentedControl.selectedSegmentIndex == 1 {
            filterSurname(searchText: searchText)
            searchBar.placeholder = "Search a Surname"
        }
        
        
    }
    func filterSurname(searchText : String) {
        if searchText.isEmpty {
            isSearching = false
            searched = ViewController.persons
        }else {
            isSearching = true
            searched = ViewController.persons.filter({ person in
                return person.surname.lowercased().contains(searchText.lowercased())
            })
        }
        tableView.reloadData()
    }
    func filterName(searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searched = ViewController.persons
        } else {
            isSearching = true
            searched = ViewController.persons.filter { person in
                return person.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
    }
}


extension ViewController {
    static var persons : [Person] = [
        Person(name: "Mahmut", surname: "Şenbek", gender: "Man"),
        Person(name: "Esra", surname: "Kart", gender: "Woman"),
        Person(name: "Ali", surname: "Veli", gender: "Man"),
        Person(name: "Murat", surname: "Zorlu", gender: "Man"),
        Person(name: "Yeşim", surname: "Salkım", gender: "Woman"),
        Person(name: "Baki", surname: "Sarsılmaz", gender: "Man"),
        Person(name: "Tarık", surname: "Malt", gender: "Man"),
        Person(name: "Bora", surname: "Ertürk", gender: "Man"),
        Person(name: "Beril", surname: "Selam", gender: "Woman"),
        Person(name: "Kerem", surname: "Yılmaz", gender: "Man"),
        Person(name: "Selim", surname: "Yakın", gender: "Man"),
        Person(name: "Hüseyin", surname: "Ertan", gender: "Man")
    ]
}
