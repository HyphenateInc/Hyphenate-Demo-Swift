//
//  EMLocationViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/26.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MBProgressHUD

@objc protocol EMLocationViewDelegate {
    func sendLocation(_ latitude: Double, _ longitude: Double, _ address: String)
}


class EMLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sendButton: UIButton!
    var _addressString: String?
    var _backAction: UIButton = {() -> UIButton in
    
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 8, height: 15)
        btn.setImage(UIImage(named:"Icon_Back"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private var _locationManager: CLLocationManager?
    private var _currentLocationCoordinate: CLLocationCoordinate2D?
    private var _isShowLocation: Bool = false
    private var _annotation: MKPointAnnotation?
    
    weak var delegate: EMLocationViewDelegate?
    
    init(location: CLLocationCoordinate2D) {
        super.init(nibName: "EMLocationViewController", bundle: nil)
        _currentLocationCoordinate = location
        _isShowLocation = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if _isShowLocation {
            removeToLocation(locationCoordinate: _currentLocationCoordinate!)
            sendButton.isHidden = true
        } else {
            mapView.showsUserLocation = true
            mapView.delegate = self
            _startLocation()
            view.bringSubview(toFront: sendButton)
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: _backAction)
    }

    func backAction () {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: Action

    @IBAction func sendLocationAction(_ sender: Any) {
        if delegate != nil && _currentLocationCoordinate != nil {
            delegate?.sendLocation((_currentLocationCoordinate?.latitude)!, (_currentLocationCoordinate?.longitude)!, _addressString!)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let geocorde = CLGeocoder()
        geocorde.reverseGeocodeLocation(userLocation.location!) { (array, error) in
            if error == nil && (array?.count)! > 0 {
                let placeMark = array?.first
                self._addressString = placeMark?.name
                self.removeToLocation(locationCoordinate: userLocation.coordinate)
            }
        }
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
 
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.notDetermined:
            _locationManager?.requestAlwaysAuthorization()
            break
        default:
            break
        }
    }
    
    // MARK: - Private
    func createAnnotation(withCoord coord: CLLocationCoordinate2D) {
        if _annotation == nil {
            _annotation = MKPointAnnotation.init()
        }else {
            mapView.removeAnnotation(_annotation!)
        }
        
        _annotation?.coordinate = coord
        mapView.addAnnotation(_annotation!)
    }
    
    func removeToLocation(locationCoordinate: CLLocationCoordinate2D) {
        MBProgressHUD.hide(for: view, animated: true)
        _currentLocationCoordinate = locationCoordinate
        let zoomLevel: Float = 0.01
        let region = MKCoordinateRegion.init(center: _currentLocationCoordinate!, span: MKCoordinateSpanMake(CLLocationDegrees(zoomLevel), CLLocationDegrees(zoomLevel)))
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        if _isShowLocation {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        self.createAnnotation(withCoord: _currentLocationCoordinate!)
    }
    
    func _startLocation() {
        MBProgressHUD.showAdded(to: view, animated: true)
        if CLLocationManager.locationServicesEnabled() {
            _locationManager = CLLocationManager()
            _locationManager?.delegate = self
            _locationManager?.distanceFilter = 5
            _locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            _locationManager?.requestAlwaysAuthorization()
        }
    }
}
