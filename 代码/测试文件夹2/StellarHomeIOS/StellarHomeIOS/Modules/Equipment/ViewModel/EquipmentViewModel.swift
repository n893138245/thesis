import UIKit
@objc protocol EquipmentViewModelDelegate {
    func pushViewController(vc:UIViewController)
}
class EquipmentViewModel:NSObject {
    let disposeBag = DisposeBag()
    weak var vMDelegate: EquipmentViewModelDelegate?
    var selctedDevices:[BasicDeviceModel] = [BasicDeviceModel]()
    private func pushToPanel(panel: PanelModel) {
        let vc = PanelDetailViewController.init()
        vc.panelModel = panel
        self.vMDelegate?.pushViewController(vc: vc)
    }
    private func doFailrueAction(cell: DeviceCollectionViewCell) {
        cell.batteryButton.ss.stopNVIndicator()
        TOAST(message: StellarLocalizedString("ALERT_CONTROL_FAIL"))
    }
    private func doSuccessAction(onOff: String,cell: DeviceCollectionViewCell) {
        cell.batteryButton.ss.stopNVIndicator()
        if onOff == "off" {
            cell.closeEquipmentWithAnimation()
        }else {
            cell.openEquipmentWithAnimation()
        }
    }
    private func showOffLineAlert(device: BasicDeviceModel) {
        let alert = DeviceOffLineAlertView.init(device: device)
        alert.deletBlock = { [weak self] in
            self?.showDeletTipAlert(device: device)
        }
        alert.resetBlock = { [weak self] in
            self?.pushToReset(device: device)
        }
        alert.show()
    }
    private func pushToReset(device: BasicDeviceModel) {
        if device.type == .hub {
            let vc = CommonReSetViewController()
            vMDelegate?.pushViewController(vc: vc)
        }else {
            let vc = AddWiFiOrResetLightViewController()
            if device.type == .light || device.type == .mainLight {
                let light = device as! LightModel
                vc.lightModel = light
            }
            vMDelegate?.pushViewController(vc: vc)
        }
    }
    private func showDeletTipAlert(device: BasicDeviceModel) {
        if device.type == .light || device.type == .mainLight {
            showHaveRelationDeletTip(device: device)
        }else {
            showNormalDeletTip(device: device)
        }
    }
    private func showNormalDeletTip(device: BasicDeviceModel) {
        let alert = StellarMineAlertView.init(message: StellarLocalizedString("ALERT_DOUBT_REMOVE_DEVICE"), leftTitle: StellarLocalizedString("ALERT_SURE_REMOVE"), rightTile: StellarLocalizedString("COMMON_CANCEL"), showExitButton: false)
        alert.show()
        alert.leftClickBlock = {
            self.deletDevice(device: device)
        }
    }
    private func showHaveRelationDeletTip(device: BasicDeviceModel) {
        let alert = StellarMineAlertView.init(title: StellarLocalizedString("ALERT_DOUBT_REMOVE_DEVICE"), message: StellarLocalizedString("ALERT_REMOVE_AFTER_SCENE_SMART_PANEL"), leftTitle: StellarLocalizedString("ALERT_SURE_REMOVE"), rightTitle: StellarLocalizedString("COMMON_CANCEL"), contentTip: nil)
        alert.show()
        alert.leftClickBlock = {
            self.deletDevice(device: device)
        }
    }
    private func deletDevice(device: BasicDeviceModel) {
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().deletDevice(device: device, success: {
            StellarProgressHUD.dissmissHUD()
            NotificationCenter.default.post(name: .NOTIFY_DEVICES_CHANGE, object: nil, userInfo: nil)
            TOAST_SUCCESS(message: StellarLocalizedString("COMMON_DELETE") + StellarLocalizedString("COMMON_SUCCESS"))
        }) {
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("COMMON_DELETE") + StellarLocalizedString("COMMON_FAIL"))
        }
    }
}
extension EquipmentViewModel:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selctedDevices.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCollectionViewCellID", for: indexPath) as! DeviceCollectionViewCell
        let model = selctedDevices[indexPath.row]
        cell.setData(model: model)
        cell.batteryClickBlock = {
            cell.batteryButton.ss.startNVIndicator(color: STELLAR_COLOR_C10)
            var onOff = ""
            if cell.deviceState == .kStateOn{ 
                onOff = "off"
            }else if cell.deviceState == .kStateNomal{ 
                onOff = "on"
            }
            CommandManager.shared.creatOnOffCommandAndSend(deviceGroup: [model as! LightModel], onOff: onOff, success: { (pResponse) in
                if let resultList = pResponse as? [[CommonResponseModel]] {
                    if resultList[1].count == 0 {
                        self.doSuccessAction(onOff: onOff, cell: cell)
                        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: self)
                    }else {
                        self.doFailrueAction(cell: cell)
                    }
                }else {
                    self.doFailrueAction(cell: cell)
                }
            }, failure: { (_, _) in
                self.doFailrueAction(cell: cell)
            })
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }, completion: { (_) in
                let selectModel = self.selctedDevices[indexPath.row]
                switch selectModel.type{
                case .unknown:
                    break
                case .light,.mainLight:
                    let light = selectModel as! LightModel
                    if !light.status.online && light.connection != .ble{
                        self.showOffLineAlert(device: light)
                        break
                    }
                    if light.connection == .ble && !StellarHomeBleManger.sharedManager.isOpenBlueTooth() {
                        StellarHomeBleManger.sharedManager.open()
                    }
                    let vc = EquipmentDetailViewController.init()
                    vc.lampModel = selectModel as? LightModel
                    self.vMDelegate?.pushViewController(vc: vc)
                case .panel:
                    let panelModel = selectModel as! PanelModel
                    self.pushToPanel(panel: panelModel)
                case .hub:
                    let gateWay = selectModel as! GatewayModel
                    if !gateWay.status.online {
                        self.showOffLineAlert(device: gateWay)
                        break
                    }
                    let vc = GetwayDetailViewController.init()
                    vc.gateWay = selectModel as! GatewayModel
                    self.vMDelegate?.pushViewController(vc: vc)
                }
            })
        }
    }
}