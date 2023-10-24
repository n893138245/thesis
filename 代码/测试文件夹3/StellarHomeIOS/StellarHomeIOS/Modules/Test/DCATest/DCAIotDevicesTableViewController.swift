import UIKit
class DCAIotDevicesTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        reloadAll()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DUIManager.sharedManager().appliances.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "dcaCell3")
        let device = DUIManager.sharedManager().appliances[indexPath.row]
        cell.textLabel?.text = device.alias == "" ? device.friendlyName : device.alias;
        cell.detailTextLabel?.text = "ID: \(device.applianceId) \(device.position == "" ? "" : "Position: \(device.position)")"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device = DUIManager.sharedManager().appliances[indexPath.row]
        showAlertView(device: device, indePath: indexPath)
    }
    func showAlertView(device: DUIIotAppliance, indePath: IndexPath) {
        let alert = UIAlertController.init(title: "Change Info", message: nil, preferredStyle: .alert);
        var postionTF: UITextField?
        var nameTf: UITextField?
        alert.addTextField { (textField) in
            textField.placeholder = "Position"
            textField.text = device.position
            postionTF = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "name"
            textField.text = device.alias
            nameTf = textField
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil));
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (alert) in
            if let tf = postionTF{
                if tf.text != device.position{
                    DUIManager.sharedManager().changeAppliancePosition(device: device, newPosition: tf.text!, success: {
                        self.tableView.reloadRows(at: [indePath], with: .none)
                    }, failure: nil)
                }
            }
            if let tf = nameTf{
                if tf.text != device.alias{
                    DUIManager.sharedManager().changeApplianceName(device: device, newName: tf.text!, success: {
                        self.tableView.reloadRows(at: [indePath], with: .none)
                    }, failure: nil)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func reloadAll() {
        for (index, value) in DUIManager.sharedManager().appliances.enumerated() {
            DUIManager.sharedManager().querySmartHomeApplianceLocation(device: value, success: {
                self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none);
            }, failure: nil)
        }
    }
}