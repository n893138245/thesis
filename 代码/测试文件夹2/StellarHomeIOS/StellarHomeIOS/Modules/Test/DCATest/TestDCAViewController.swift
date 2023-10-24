import UIKit
import MBProgressHUD
class TestDCAViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "testCell1")
        tableView.tableFooterView = UIView.init()
    }
    @IBOutlet weak var tableView: UITableView!
    let funcNames: [String] = ["BindAccount", "GetCode", "BindSansiSkill", "BindDevice", "QueryIOTDevices", "QueryHubDevices"]
}
extension TestDCAViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return funcNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "testCell1")
        cell.textLabel?.text = funcNames[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        switch indexPath.row {
        case 0:
            DUIManager.sharedManager().testLinkWithDUI(success: {
                MBProgressHUD.hide(for: self.view, animated: true)
                MBProgressHUD.showStellarHudSuccessfulWith("success", successBlock: nil)
                cell?.detailTextLabel?.text = "Login success"
            }, failure: { (code, message) in
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        case 1:
            DUIManager.sharedManager().getAuthCode(success: {
                MBProgressHUD.hide(for: self.view, animated: true)
                MBProgressHUD.showStellarHudSuccessfulWith("success", successBlock: nil)
                cell?.detailTextLabel?.text = "DUIAuthCode: \(DUIManager.sharedManager().duiAuthCode ?? "")"
            }, failure: {
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        case 2:
            DUIManager.sharedManager().bindSansiSmartHomeSkill(accessToken: dui_testSansiToken, refreshToken: dui_testSansiRefreshToken, success: {
                MBProgressHUD.hide(for: self.view, animated: true)
                MBProgressHUD.showStellarHudSuccessfulWith("success", successBlock: nil)
            }) {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        case 3:
            DUIManager.sharedManager().testBindDevice(success: {
                MBProgressHUD.hide(for: self.view, animated: true)
                MBProgressHUD.showStellarHudSuccessfulWith("success", successBlock: nil)
            }, failure: {
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        case 4:
            DUIManager.sharedManager().qureySmartHomeAppliances(success: {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.navigationController?.pushViewController(DCAIotDevicesTableViewController(), animated: true);
            }, failure: {
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        case 5:
            DUIManager.sharedManager().queryHubDvices(success: {
                MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: {
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        default:
            break
        }
    }
}