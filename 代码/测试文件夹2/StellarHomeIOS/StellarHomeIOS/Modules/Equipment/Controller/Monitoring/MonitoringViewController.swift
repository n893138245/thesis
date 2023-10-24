import UIKit
class MonitoringViewController: BaseViewController {
    var lampModel: LightModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        getDatas()
    }
    private func getDatas() {
        netGetTraject()
        NotificationCenter.default.rx.notification(.NOTIFY_RADARLOCATIONINFO)
            .subscribe(onNext: { [weak self] (notify) in
                guard let locationList = notify.userInfo?["radarLocationInfo"] as? [[String: Int]] else {
                    return
                }
                var locations = [RadarLocationInfo]()
                for dic in locationList {
                    let loaction = dic.kj.model(RadarLocationInfo.self)
                    locations.append(loaction)
                }
                self?.trajectoryView.addAnimationPoints(locations: locations)
            }).disposed(by: disposeBag)
    }
    private func setupUI() {
        view.addSubview(trajectoryView)
    }
    private func setupActions() {
        trajectoryView.clickStartBlock = { [weak self] in
            guard let isOpenRealTime = self?.trajectoryView.isOpeningRealTime else {
                return
            }
            isOpenRealTime ? self?.netStopMonitorTrajectory():self?.netStartMonitorTrajectory()
        }
    }
    private func netGetTraject() {
        DevicesStore.instance.getLocations(sn: lampModel?.sn ?? "") { [weak self] (info) in
            self?.trajectoryView.addNormalPointViews(locations: info)
        } failure: { (error) in
            print(error)
        }
    }
    private func netStartMonitorTrajectory() {
        trajectoryView.startLoading()
        DevicesStore.instance.start_MonitoringLocation(sn: lampModel?.sn ?? "") { [weak self] (jsonDic) in
            self?.trajectoryView.stopLoading()
            guard let response = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel else {
                return
            }
            if response.code == 0 {
                self?.trajectoryView.openRealTimeMode()
            }else {
                self?.trajectoryView.showNormalMode()
            }
        } failure: { (error) in
            self.trajectoryView.stopLoading()
            self.trajectoryView.showNormalMode()
            TOAST(message: "开启失败，请重试")
        }
    }
    private func netStopMonitorTrajectory() {
        trajectoryView.startLoading()
        DevicesStore.instance.stop_MonitoringLocation(sn: lampModel?.sn ?? "") { [weak self] (jsonDic) in
            self?.trajectoryView.stopLoading()
            guard let response = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel else {
                return
            }
            if response.code == 0 {
                self?.trajectoryView.showNormalMode()
            }else {
                self?.trajectoryView.openRealTimeMode()
            }
        } failure: { (error) in
            self.trajectoryView.stopLoading()
            self.trajectoryView.openRealTimeMode()
            TOAST(message: "关闭失败，请重试")
        }
    }
    lazy var trajectoryView: TrajectoryView = {
        let tempView = TrajectoryView.init(frame: CGRect(x: 0, y: kNavigationH + 13, width: kScreenWidth, height: 324))
        tempView.backgroundColor = .white
        return tempView
    }()
}