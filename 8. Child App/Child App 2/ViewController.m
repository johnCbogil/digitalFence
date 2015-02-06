//
//  ViewController.m
//  Child App 2
//
//  Created by Aditya Narayan on 9/25/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize userID;
@synthesize latitude;
@synthesize longitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CoreLocation Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *clLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = [clLocation coordinate];
    latitude = [[NSNumber numberWithDouble:coordinate.latitude]stringValue];
    longitude = [[NSNumber numberWithDouble:coordinate.longitude]stringValue];
    userID = self.usernameTextField.text;
    
    NSLog(@"\n\nlatitude: %@\nlongitude: %@\n\n", latitude, longitude);
    
    callCount++;
    if(!(callCount %5 == 0)){
        return;
    }
    else
    {
        NSDictionary *childDict = @{@"utf8": @"✓", @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=", @"user":@{@"username":self.userID,@"current_lat":self.latitude,@"current_longitude":self.longitude}, @"commit":@"Create User", @"action":@"update", @"controller":@"users"};
        NSString *urlString = [NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@", userID];
        NSLog(@"%@\n\n", urlString);
        [self patchRequest:urlString withData:[self JSON_data: childDict]];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - patchRequest

-(void)patchRequest:(NSString *)url_name withData:(NSData*)data
{
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_name]];
    
    // Specify that it will be a PATCH request
    request.HTTPMethod = @"PATCH";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = data;
    NSLog(@"\n\n%@", request.HTTPBody);
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    conn = nil;
}

-(NSData*)JSON_data:(NSDictionary*)dictionary
{
    NSError *error;
    NSData *jsonData;
    
   
    if([NSJSONSerialization isValidJSONObject:dictionary])
        
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    }
    if(!jsonData)
    {
        NSLog(@"toJSON: error: %@", error.localizedDescription);
        return nil;
    }
    else
    {

        NSLog(@"\n\n%@", jsonData);
        return jsonData;
    }
}

    
    
    
    
    


- (IBAction)activateButton:(UIButton *)sender {
    [locationManager startUpdatingLocation];
}
@end
