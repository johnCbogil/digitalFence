//
//  ViewController.h
//  Child App 2
//
//  Created by Aditya Narayan on 9/25/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

{
NSString *userID;
CLLocationManager *locationManager;
NSString *latitude, *longitude;
int callCount;
}




// Properties
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *latitude, *longitude;

// labels
@property (weak, nonatomic) IBOutlet UILabel *digitalLeash;
@property (weak, nonatomic) IBOutlet UILabel *forChildren;

// text field
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

// button
- (IBAction)activateButton:(UIButton *)sender;

@end

