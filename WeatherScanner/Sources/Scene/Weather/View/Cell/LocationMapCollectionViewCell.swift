//
//  LocationMapCollectionViewCell.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit
import MapKit

final class LocationMapCollectionViewCell: BaseCollectionViewCell {
    let mapView = MKMapView()
    
    func configureCell(locationCoor: CLLocationCoordinate2D) {
        setRegion(locationCoor)
        setAnnotation(locationCoor)
    }
    
    func setRegion(_ locationCoor: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)
        mapView.region = MKCoordinateRegion(center: locationCoor, span: span)
    }
    
    func setAnnotation(_ center: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        
        // 맵뷰에 Annotaion 추가
        mapView.addAnnotation(annotation)
    }
    
    override func configureHierarchy() {
        addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        mapView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.layer.cornerRadius = 14
    }
}
