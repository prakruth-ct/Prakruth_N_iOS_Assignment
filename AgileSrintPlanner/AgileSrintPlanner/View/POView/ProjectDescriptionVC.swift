import UIKit

class ProjectDescriptionVC: BaseVC {
    
    var tableView: UITableView!
    var projectDetails: ProjectDetails?
    var projectDetailsArr: [String] = []
    let headings = ["Title", "Domain", "Description"]
    let sectionHeading = ["Project Description", "Product Backlogs", "Team"]
    
    var viewModel = POViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        projectDetailsArr = [projectDetails?.data.title, projectDetails?.data.domain, projectDetails?.data.descp] as? [String] ?? [""]
        navigationItem.title = projectDetailsArr[0]
    }
}

extension ProjectDescriptionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.ProjectDescription.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeading[section]
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
        
        //if indexPath.row == 0 {
        switch indexPath.section {
        case Constants.ProjectDescription.Sections.description.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectDescriptionTVCell.self), for: indexPath) as? ProjectDescriptionTVCell else { fatalError() }
            
            cell.label.text = headings[indexPath.row]
            cell.textToDisplay.text = projectDetailsArr[indexPath.row]
            return cell
        case Constants.ProjectDescription.Sections.backlogs.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductBacklogTVCell.self), for: indexPath) as? ProductBacklogTVCell else { fatalError() }
            
                    return cell
        case Constants.ProjectDescription.Sections.team.rawValue:
            //UNDER IMPLEMENTATION
            return ProductBacklogTVCell()
        default:
            return ProductBacklogTVCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
