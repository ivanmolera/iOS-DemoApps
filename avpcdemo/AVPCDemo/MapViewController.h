//
//  MapViewController.h
//  AVPCDemo
//
//  Created by IVAN MOLERA on 4/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem    *sidebarButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *rightbarButton;
@property (nonatomic, strong) IBOutlet MKMapView        *mapa;

@property (nonatomic, strong) CLLocationManager         *locationManager;
@property (nonatomic, strong) CLGeocoder                *geocoder;

@property (nonatomic, strong) MKPolygon                 *regionPolygon;
@property (nonatomic, strong) MKCircle                  *circle;

- (IBAction)locateDevice:(id)sender;

@end
