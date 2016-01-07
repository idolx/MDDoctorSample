//
//  MDAddAppointmentViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/30.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let reuseIdentifier = "patientSearchResultCell"

class MDAddAppointmentViewController: UITableViewController {
    
    private var filterPatients = [MDPatientModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")

        prepareSearchBar()
    }
    
    
//MARK: - callBack method
    
    @objc private func cancel() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func prepareSearchBar() {
    
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "Male", "Female"]
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        searchController.active = true
    }
    
    
//MARK: - lazy load
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var patients: [MDPatientModel] = {
        
        let patientKeyValues = [
        
            ["FirstName": "Jim", "PatientGender": "Male", "PatientMobilePhone": "123-456-789"],
            ["FirstName": "Lily", "PatientGender": "Female", "PatientMobilePhone": "111-222-333"],
            ["FirstName": "Lilei", "PatientGender": "Male", "PatientMobilePhone": "88888888"],
            ["FirstName": "Lucy", "PatientGender": "Female", "PatientMobilePhone": "11-22-33-44"],
            ["FirstName": "Jack", "PatientGender": "Male", "PatientMobilePhone": "777-11-777"]
        ]
        
        var patients = [MDPatientModel]()
    
        for dict in patientKeyValues {
        
            let patientModel = MDPatientModel(dict: dict)
            
            patients.append(patientModel)
        }
        
        return patients
    }()
}


extension MDAddAppointmentViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.searchBar.text != "" && searchController.active {
        
            return filterPatients.count
        }
        
        return patients.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var patient: MDPatientModel!
        
        if searchController.searchBar.text != "" && searchController.active {
        
            patient = filterPatients[indexPath.row]
        }
        else {
        
            patient = patients[indexPath.row]
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
        
            cell.textLabel?.text = patient.FirstName
            cell.detailTextLabel?.text = patient.PatientMobilePhone! + " " + patient.PatientGender!
            
            return cell
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        
        cell.textLabel?.text = patient.FirstName
        cell.detailTextLabel?.text = patient.PatientMobilePhone! + " " + patient.PatientGender!
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchController.active = false
        
        let appointmentVC = MDAppointmentViewController()
        
        appointmentVC.patient = patients[indexPath.row]
        
        navigationController?.pushViewController(appointmentVC, animated: true)
    }
}


extension MDAddAppointmentViewController: UISearchBarDelegate, UISearchResultsUpdating {

    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        cancel()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchBar.text!, scope: scope)
    }
    
    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filterPatients = patients.filter({(patient: MDPatientModel) -> Bool in
            
            let categoryMatch = (scope == "All") || (patient.PatientGender == scope)
            
            return categoryMatch && patient.FirstName!.lowercaseString.containsString(searchText.lowercaseString)
        })
        
        tableView.reloadData()
    }
}

