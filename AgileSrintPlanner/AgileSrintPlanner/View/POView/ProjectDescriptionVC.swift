import UIKit

class ProjectDescriptionVC: BaseVC {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newUserButton: UIButton!
    
    var projectDetails: ProjectDetails?
    var projectDetailsArr: [String] = []
    var updateDetails: [String] = []
    var viewModel = POViewModel()
//    var projectTitle: String?
//    let projectName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        projectDetailsArr = [projectDetails?.data.title, projectDetails?.data.domain, projectDetails?.data.descp] as? [String] ?? [""]
        print(projectDetails?.teamMember)
        navigationItem.title = projectDetailsArr.first
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.NavigationBarConstants.editTitle, style: .plain, target: self, action: #selector(editNavBarItemDidPress))
        tableView.tableFooterView = UIView()
        newUserButton.layer.cornerRadius = newUserButton.imageView?.frame.width ?? 1.0 / 2
    }
    
    func getAndReloadData(projectName: String) {
        startLoading()
        viewModel.getProjectDetailsForUserWith(email: UserDefaults.standard.object(forKey: Constants.UserDefaults.currentUserName) as? String ?? "", completion: { [weak self] in
            guard let self = self else { return }
            
            self.stopLoading()
            self.getCurrentProjectDetails(projectName: projectName)
            self.projectDetailsArr = [self.projectDetails?.data.title, self.projectDetails?.data.domain, self.projectDetails?.data.descp] as? [String] ?? [""]
            self.stopLoading()
        })
    }
    
    private func getCurrentProjectDetails(projectName: String) {
        guard let projectDetailsToSearch = viewModel.projectDetails else { return }
        
        for project in projectDetailsToSearch {
            if project.data.title == projectName {
                projectDetails = project
                return
            }
        }
    }
    
    //Edit button action function
    @objc func editNavBarItemDidPress() {
        if !viewModel.editCondition {
            viewModel.editCondition = true
            newUserButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.NavigationBarConstants.doneTitle, style: .plain, target: self, action: #selector(editNavBarItemDidPress))
        } else {
            for row in 0..<Constants.ProjectDescription.rowsInDescription {
                guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ProjectDescriptionTVCell else { return }
            
                updateDetails.append(cell.textToDisplay.text)
            }
            viewModel.editCondition = false
            newUserButton.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.NavigationBarConstants.editTitle, style: .plain, target: self, action: #selector(editNavBarItemDidPress))
            let confirmAction = UIAlertAction(title: Constants.AlertMessages.confirmChanges, style: .default) { [weak self] (_) in
                guard let self = self,
                      let poName = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentUserName) as? String else { return }
                
                self.startLoading()
                self.viewModel.updateDetailsOfProject(title: self.projectDetailsArr.first ?? Constants.NilCoalescingDefaults.string, updateDetails: self.updateDetails, members: [Constants.FirebaseConstants.poNameInAddProject: poName]) { [weak self] in
                    guard let self = self else { return }
                    
                    self.stopLoading()
                    self.showAlert(title: Constants.AlertMessages.successAlert, msg: Constants.AlertMessages.successUpdate, actionTitle: Constants.AlertMessages.closeAction)
                    self.getAndReloadData(projectName: self.updateDetails[0])
                }
            }
            let declineAction = UIAlertAction(title: Constants.AlertMessages.checkAgain, style: .cancel, handler: nil)
            showAlert(title: Constants.AlertMessages.confirmChanges, msg: Constants.AlertMessages.confirmMessage, alertStyle: .alert, actions: [confirmAction, declineAction])
        }
        tableView.reloadData()
    }
    
    @IBAction private func addNewUserButtonDidPress(_ button: UIButton) {
        
    }
}

extension ProjectDescriptionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.ProjectDescription.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionHeading[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Constants.ProjectDescription.Sections.description.rawValue:
            return Constants.ProjectDescription.rowsInDescription
        case Constants.ProjectDescription.Sections.backlogs.rawValue:
            return Constants.ProjectDescription.rowsInBacklogs
        case Constants.ProjectDescription.Sections.team.rawValue:
            return Constants.ProjectDescription.rowsInTeam
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionItem = Constants.ProjectDescription.Sections(rawValue: indexPath.section)
        switch sectionItem ?? .description {
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectDescriptionTVCell.self), for: indexPath) as? ProjectDescriptionTVCell else { return ProjectDescriptionTVCell() }
            
            cell.label.text = viewModel.headings[indexPath.row]
            cell.textToDisplay.text = projectDetailsArr[indexPath.row]
            if viewModel.editCondition {
                cell.textToDisplay.isUserInteractionEnabled = true
                cell.textToDisplay.isEditable = true
            } else {
                cell.textToDisplay.isEditable = false
                cell.textToDisplay.isUserInteractionEnabled = false
            }
            return cell
        case .backlogs:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductBacklogTVCell.self), for: indexPath) as? ProductBacklogTVCell else { return ProjectDescriptionTVCell() }
            
            return cell
        case .team:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TeamMembersTVCell.self), for: indexPath) as? TeamMembersTVCell else { return TeamMembersTVCell() }
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case Constants.ProjectDescription.Sections.team.rawValue:
            return 0.4609 * view.frame.height
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProjectDescriptionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return projectDetails?.teamMember.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TeamDisplayCVCell.self), for: indexPath) as? TeamDisplayCVCell else { return TeamDisplayCVCell() }

        cell.imageView.image = UIImage(named: "Teamwork-Theme")
        cell.imageView.layer.cornerRadius = cell.imageView.frame.width / 2
        cell.nameLabel.text = projectDetails?.teamMember[indexPath.row].name
        cell.roleLabel.text = projectDetails?.teamMember[indexPath.row].role
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRow = CGFloat(2)
        let availableWidth = collectionView.frame.size.width - CGFloat(Constants.CollectionViewCell.leftSpacing)
        let widthPerItem = availableWidth / cellsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
