//
//  ViewController.h
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


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager *manager;
    CLLocationDistance accuracy;
    CLRegion *regionCourante;
    CLLocationCoordinate2D centre;
    
}

@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *coordonneesCibles;
@property (weak, nonatomic) IBOutlet UISlider *accuracySlider;
@property (weak, nonatomic) IBOutlet UILabel *labelAccuracy;
@property (strong, nonatomic) CLLocationManager *manager;
@property CLLocationDistance accuracy;
@property (strong, nonatomic) CLRegion *regionCourante;
@property CLLocationCoordinate2D centre;
@property (weak, nonatomic) IBOutlet UIButton *setCoordinatesButton;
@property (weak, nonatomic) IBOutlet UILabel *distance;

- (IBAction)determinerAccuracy:(id)sender;
- (void) startStandardUpdates;
- (void) startRegionMonitoring;
- (IBAction)setCoordinates:(id)sender;
- (CLLocationDistance) distanceEntre: (CLLocationCoordinate2D) center et: (CLLocation *) position;
@end
