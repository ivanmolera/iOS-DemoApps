//
//  MapViewController.m
//  AVPCDemo
//
//  Created by IVAN MOLERA on 4/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "RightViewController.h"
#import "Annotation.h"
#import "ListViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

        [self.rightbarButton setTarget: self.revealViewController];
        [self.rightbarButton setAction: @selector( rightRevealToggle: )];
        
        RightViewController *rightViewController = [[RightViewController alloc] init];
        [revealViewController setRightViewController:rightViewController];
    }
    
    _locationManager = [[CLLocationManager alloc] init];

    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];


    // Abans de posar un nou pin, esborro els anteriors
    for (id annotation in _mapa.annotations) {
        [_mapa removeAnnotation:annotation];
    }
    
    [_mapa setMapType:MKMapTypeHybrid];
    [_mapa setShowsPointsOfInterest:NO];
    [_mapa setDelegate:self];

    // DEMO
    [self setDemoItems];
}

- (void) setDemoItems {

    /////// Init mapa
    CLLocation *location = [[CLLocation alloc] initWithLatitude:41.665609
                                                      longitude:1.863948];

    [self setRegionWithCoords:location.coordinate];

    
    // CECOPAL
    Annotation *cecopal = [[Annotation alloc] initAnnotationWithCoordinates:location.coordinate type:CECOPAL title:@"CECOPAL" subtitle:[NSString stringWithFormat:@"(%f, %f)", location.coordinate.latitude, location.coordinate.longitude] andStatusReady:YES];
    
    [_mapa addAnnotation:cecopal];


    // VOLUNTARI
    CLLocation *volunteer_01 = [[CLLocation alloc] initWithLatitude:41.669979
                                                            longitude:1.858619];
    
    Annotation *anotacion_01 = [[Annotation alloc] initAnnotationWithCoordinates:volunteer_01.coordinate type:VOLUNTEER title:@"Xavier Vallverdú" subtitle:@"Voluntari" andStatusReady:YES];
    
    [_mapa addAnnotation:anotacion_01];
    [_mapa addOverlay: [anotacion_01 circle]];

    // VOLUNTARI
    CLLocation *volunteer_02 = [[CLLocation alloc] initWithLatitude:41.666437
                                                          longitude:1.855926];
    
    Annotation *anotacion_02 = [[Annotation alloc] initAnnotationWithCoordinates:volunteer_02.coordinate type:VOLUNTEER title:@"Jordi Viladoms" subtitle:@"Voluntari" andStatusReady:NO];

    [_mapa addAnnotation:anotacion_02];

    // VOLUNTARI
    CLLocation *volunteer_03 = [[CLLocation alloc] initWithLatitude:41.672880
                                                          longitude:1.862803];
    
    Annotation *anotacion_03 = [[Annotation alloc] initAnnotationWithCoordinates:volunteer_03.coordinate type:VOLUNTEER title:@"Joan Martín" subtitle:@"Voluntari" andStatusReady:YES];

    [_mapa addAnnotation:anotacion_03];
    [_mapa addOverlay: [anotacion_03 circle]];
    
    // FOC
    CLLocation *fire_01 = [[CLLocation alloc] initWithLatitude:41.673890
                                                          longitude:1.869648];
    
    Annotation *anotacion_04 = [[Annotation alloc] initAnnotationWithCoordinates:fire_01.coordinate type:FIRE title:@"Incendi forestal" subtitle:@"" andStatusReady:YES];
    
    [_mapa addAnnotation:anotacion_04];
    [_mapa addOverlay: [anotacion_04 circle]];
}

- (void) setRegionWithCoords:(CLLocationCoordinate2D)coords {
    // Regió en metres
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coords, 1000, 1000);
    
    // Setejo la regió al mapa
    [_mapa setRegion:region animated:YES];
    // Ajustem l'aspect ratio per assegurar que el mapa queda dins de la vista
    [_mapa regionThatFits:region];
}

// Sobreescribimos el método para poder modificar elementos de la anotación como la imagen.
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id) annotation {
    
    // Sólo las anotaciones costumizadas
    if([annotation isKindOfClass:[Annotation class]] == NO) {
        return nil;
    }
    
    Annotation *anotacion = (Annotation*)annotation;
    
    return [anotacion annotationView];
}

- (IBAction)locateDevice:(id)sender {

    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }

    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        Annotation *user = [[Annotation alloc] initAnnotationWithCoordinates:currentLocation.coordinate
                                                                        type:VOLUNTEER title:@"Ets tu!"
                                                                    subtitle:[NSString stringWithFormat:@"(%.8f, %.8f)", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude]
                                                              andStatusReady:YES];
        
        [_mapa addAnnotation:user];
        [_mapa selectAnnotation:user animated:YES];
        //[_mapa addOverlay: [user circle]];
    }

    // Aturo l'actualització de localització, només vull la posició quan apreten el botó
    [_locationManager stopUpdatingLocation];

    [self setRegionWithCoords:currentLocation.coordinate];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"No s'ha pogut localitzar el dispositiu"
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    
    [alerta show];
    
    NSLog(@"No s'ha pogut localitzar el dispositiu");
    NSLog(@"didFailWithError: %@", error);
}

#pragma mark - MapKit Delegate Methods

- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {

    MKCircle *circle = (MKCircle*)overlay;

    MKCircleRenderer *circleRenderer   = [[MKCircleRenderer alloc] initWithOverlay:overlay];

    UIColor *color = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.2f];
    UIColor *colorStroke = [UIColor redColor];

    if([circle radius] < 50) {
        color = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.2f];
        colorStroke = [UIColor greenColor];
    }

    circleRenderer.strokeColor         = colorStroke;
    circleRenderer.fillColor           = color;
    circleRenderer.lineWidth           = 2.0f;

    return circleRenderer;
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"showList"]) {
         UINavigationController *navController = segue.destinationViewController;
         ListViewController *listController = [navController childViewControllers].firstObject;
         
         [listController loadDataSourceWithEndPoint:WS_LIST_MEMBERS];
     }
 }

@end
