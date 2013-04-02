//
//  ViewController.m
//  DidEnterRegion
//
//  Created by Gaurav on 01/08/12.

//  Copyright (c) 2012 sparshme5@gmail.com. All rights reserved.

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "ViewController.h"
#define radianConst M_PI/180.0
#define EARTHRADIUS 6371

@implementation ViewController
@synthesize longitude;
@synthesize latitude;
@synthesize coordonneesCibles;
@synthesize accuracySlider;
@synthesize labelAccuracy;
@synthesize manager;
@synthesize accuracy;
@synthesize regionCourante;
@synthesize centre;
@synthesize setCoordinatesButton;
@synthesize distance;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    setCoordinatesButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.accuracy = self.accuracySlider.value;
    self.labelAccuracy.text = [NSString stringWithFormat:@"%.1f", self.accuracy];

    accuracySlider.transform = CGAffineTransformRotate(accuracySlider.transform, 270.0/180*M_PI);
    
    CGPoint sliderCentre = CGPointMake([[UIScreen mainScreen] bounds].size.width - 35, distance.center.y);
    CGSize size = CGSizeMake(15, [[UIScreen mainScreen] bounds].size.height - 125);
    CGRect frame = {sliderCentre, size};
    
    self.accuracySlider.frame = frame;
    
    [self startStandardUpdates];
    
    
    if ([CLLocationManager regionMonitoringAvailable]) {
        [self startRegionMonitoring];
        NSLog(@"Region monitoring available");
    }
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [self setLongitude:nil];
    [self setLatitude:nil];
    [self setCoordonneesCibles:nil];
    [self setAccuracySlider:nil];
    [self setLabelAccuracy:nil];
    [self setSetCoordinatesButton:nil];
    [self setDistance:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) locationManager:(CLLocationManager *)_manager 
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {

    self.latitude.text = [NSString stringWithFormat:@"Latitude : %f", newLocation.coordinate.latitude] ;
    self.longitude.text = [NSString stringWithFormat:@"Longitude : %f", newLocation.coordinate.longitude] ;
    
    NSLog(@"Latitude : %f, Longitude : %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    NSLog(@"Count: %i", _manager.monitoredRegions.count);
    CLRegion *region;// = (CLRegion *) _manager.monitoredRegions.anyObject;
    int i = 1;
    for (region in _manager.monitoredRegions) {
        NSLog(@"%i. Lat : %f, Long : %f, Radius: %f", i, region.center.latitude, region.center.longitude, region.radius);
        i++;
    }
    
    
    distance.text = [NSString stringWithFormat:@"Distance: %.2fm", [self distanceEntre: centre et: newLocation]];


}

- (CLLocationDistance) distanceEntre:(CLLocationCoordinate2D) center et:(CLLocation *) position {
    double centerLat = center.latitude * radianConst;
    double centerLong = center.longitude * radianConst;
    double positionLat = position.coordinate.latitude * radianConst;
    double positionLong = position.coordinate.longitude * radianConst;
    
    double deltaLat = centerLat - positionLat;
    double deltaLong = centerLong - positionLong;
    
    double a = pow(sin(deltaLat/2), 2)
    + cos(centerLat) * cos(positionLat) * pow(sin(deltaLong/2), 2);
    double c = 2 * atan2(pow(a, 0.5), pow(1 - a, 0.5));
    
    return c * EARTHRADIUS * 1000;
}

- (void)startStandardUpdates
{
    manager = [[CLLocationManager alloc] init]; 
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = kCLDistanceFilterNone;
    
    [manager startUpdatingLocation];
//    [manager startMonitoringSignificantLocationChanges];
}

- (void)startSignificantChangeUpdates {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init]; 
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)startRegionMonitoring
{
    NSLog(@"Starting region monitoring");
        
    // Pass establishment lat long here
    centre = CLLocationCoordinate2DMake(18.5353662, 73.8985708);
    regionCourante = [[CLRegion alloc] initCircularRegionWithCenter:centre radius:5.0 identifier:@"Bingo"];
    coordonneesCibles.text = [NSString stringWithFormat: @"Coord Cibles\nLatitude : %f\nLongitude : %f", centre.latitude, centre.longitude];
    [manager startMonitoringForRegion:regionCourante];
}

- (IBAction)setCoordinates:(id)sender {
    [manager stopMonitoringForRegion:regionCourante];
    centre = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
    regionCourante = [[CLRegion alloc] initCircularRegionWithCenter: centre radius: accuracy identifier: @"Region"];
    coordonneesCibles.text = [NSString stringWithFormat: @"Coord Cibles\nLatitude : %f\nLongitude : %f", centre.latitude, centre.longitude];
    [manager startMonitoringForRegion: regionCourante];
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"didEnterRegion");
    [self doAlert];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert" 
                                                    message:@"You entered the region" 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"didExitRegion");
    [self donotAlert];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert"
                                                    message:@"You exited the region" 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Monitoring failed");
}


- (IBAction)determinerAccuracy:(id)sender {
    [manager stopMonitoringForRegion:regionCourante];
    self.accuracy = accuracySlider.value;
    regionCourante = [[CLRegion alloc] initCircularRegionWithCenter: centre radius: accuracy identifier: @"Region"];

    [manager startMonitoringForRegion:regionCourante];
    self.labelAccuracy.text = [NSString stringWithFormat:@"%.1f", [regionCourante radius]];
    
}

 -(void)doAlert
{
         UIAlertView *alertDialog;
         UILocalNotification *scheduledAlert;
    
         alertDialog = [[UIAlertView alloc]
                                              initWithTitle: @"Local Notification"
                                            message:@"oh! my good that you enter in my area"
                                              delegate: nil
                                              cancelButtonTitle: @"Ok"
                                              otherButtonTitles: nil];
    
         [alertDialog show];
    
    
         [[UIApplication sharedApplication] cancelAllLocalNotifications];
         scheduledAlert = [[UILocalNotification alloc] init];
         scheduledAlert.applicationIconBadgeNumber=1;
         scheduledAlert.fireDate = [NSDate dateWithTimeIntervalSinceNow:300];
         scheduledAlert.timeZone = [NSTimeZone defaultTimeZone];
         scheduledAlert.repeatInterval =  NSDayCalendarUnit;
         scheduledAlert.alertBody = @"oh! my good that you enter in my area!";
    
         [[UIApplication sharedApplication] scheduleLocalNotification:scheduledAlert];
    
     }

-(void)donotAlert
{
    UIAlertView *alertDialog;
    UILocalNotification *scheduledAlert;
    
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Local Notification"
                   message:@"oh! my bad youre leaving this area!"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    
    [alertDialog show];
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    scheduledAlert = [[UILocalNotification alloc] init];
    scheduledAlert.applicationIconBadgeNumber=1;
    scheduledAlert.fireDate = [NSDate dateWithTimeIntervalSinceNow:300];
    scheduledAlert.timeZone = [NSTimeZone defaultTimeZone];
    scheduledAlert.repeatInterval =  NSDayCalendarUnit;
    scheduledAlert.alertBody = @"oh! my bad youre leaving this area!";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:scheduledAlert];
    
}


@end
