//
//  ViewController.m
//  MobileMapper
//
//  Created by Chee Vue on 5/27/15.
//  Copyright (c) 2015 Chee Vue. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *mobileMakersAnnotation; //point that represent the pin
@property CLLocationManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //San Diego Airport : 32.7336° N, 117.1897° W
    double latittude = 41.89373984;
    double longitude = -87.635392979;

    self.mobileMakersAnnotation = [MKPointAnnotation new];
    self.mobileMakersAnnotation.coordinate = CLLocationCoordinate2DMake(latittude, longitude);
    self.mobileMakersAnnotation.title = @"Mobile Makers";
    [self.mapView addAnnotation:self.mobileMakersAnnotation];

    [self loadAddressString:@"San Diego Airport"];
    [self loadAddressString:@"593 Eileen St, Brentwood, CA 94513"];
    [self loadAddressString:@"Sacramento, CA"];

    self.manager = [CLLocationManager new];

    //dont forget to update your plist
    [self.manager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;



}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    if (annotation == mapView.userLocation) {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    //view
    pin.canShowCallout = YES;

    if (annotation == self.mobileMakersAnnotation) {
        pin.image = [UIImage imageNamed:@"mobilemakers"];
    }

    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

-(void)loadAddressString:(NSString *)addressString{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            //add i button
            annotation.title = placemark.name;
            annotation.coordinate = placemark.location.coordinate;
            [self.mapView addAnnotation:annotation];
        }
    }];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    MKCoordinateRegion region = MKCoordinateRegionMake(view.annotation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
}

@end
