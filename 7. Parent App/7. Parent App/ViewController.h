//
//  ViewController.h
//  7. Parent App
//
//  Created by Aditya Narayan on 9/23/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;


//labels
@property (weak, nonatomic) IBOutlet UILabel *digitalLeash;
@property (weak, nonatomic) IBOutlet UILabel *forParents;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *enterLocation;
@property (strong, nonatomic) IBOutlet UILabel *status;


//text fields
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;




//Data properties
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *radius;
@property (nonatomic, strong) NSString *placeholderlat;
@property (nonatomic, strong) NSString *placeholderlong;






//buttons
- (IBAction)createUser:(UIButton *)sender;
- (IBAction)updateLocation:(UIButton *)sender;
- (IBAction)findChild:(UIButton *)sender;


@end

