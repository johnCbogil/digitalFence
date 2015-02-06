//
//  ViewController.m
//  7. Parent App
//
//  Created by Aditya Narayan on 9/23/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

//@interface ViewController()
//@end



#pragma mark - location updating
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CLLocationManager alloc] init];
    [self.manager requestAlwaysAuthorization];
    
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
    {
        
        //NSLog(@"Location: %@", newLocation);
        CLLocation *currentLocation = newLocation;
        self.latitudeTextField.placeholder = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        self.longitudeTextField.placeholder = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - connection methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}
-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
    NSLog(@"%@", decodedData);
    id zoneValue = [decodedData objectForKey:@"is_in_zone"];
    if([zoneValue boolValue] == false){
        NSLog(@"%@", decodedData);
        self.status.text = @"your child is NOT within the geo-fence";
    }
    else{
        NSLog(@"%@", decodedData);
        self.status.text = @"your child is within the geo-fence";
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error = %@", [error localizedDescription]);
}


#pragma mark - request methods

-(void)postRequest {
    
    if(![self.latitudeTextField.text  isEqual: nil])
        self.latitude = self.latitudeTextField.placeholder;
    else
        self.latitude = self.latitudeTextField.text;
    
    if(![self.longitudeTextField.text isEqual: nil])
        self.longitude = self.longitudeTextField.placeholder;
    else
        self.longitude = self.longitudeTextField.text;
    
    
    self.userID = self.usernameTextField.text;
    self.radius = self.radiusTextField.text;
    
    
    // user data that will be sent to server
    NSDictionary *userDetails = @{@"utf8": @"✓", @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=",
                    @"user":@{@"username": self.userID,
                              @"radius":self.radius,
               @"latitude":self.latitude,
         @"longitude":self.longitude},
                    @"commit":@"Createuser",
                    @"action":@"update",
                @"controller":@"users"};
    // must convert the json data to NSObject
    NSData *jsonUserDetails = [NSJSONSerialization dataWithJSONObject:userDetails options:NSJSONWritingPrettyPrinted error:nil];
    // Create the request
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL
                                                              URLWithString:@"http://protected-wildwood-8664.herokuapp.com/users"]];
    // Specify that the request will be a POST
    postRequest.HTTPMethod = @"POST";
    // Set the header fields
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // Not sure what happens here **** takes json and converts to string?? ******
    NSMutableString *stringData = [[NSMutableString alloc]initWithData:jsonUserDetails
                                                              encoding:NSUTF8StringEncoding];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    postRequest.HTTPBody = requestBodyData;
    // Create URL connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    conn = nil;
}

-(void)patchRequest {
    
    
    self.userID = self.usernameTextField.text;
    self.latitude = self.latitudeTextField.text;
    self.longitude = self.longitudeTextField.text;
    self.radius = self.radiusTextField.text;
    
    
    // user data that will be sent to server
    NSDictionary *userDetails = @{@"utf8": @"✓",
                                  @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=",
                                  @"user":@{@"username": self.userID,
                                              @"radius":self.radius,
                                            @"latitude":self.latitude,
                                           @"longitude":self.longitude},
                                              @"commit":@"Createuser",
                                              @"action":@"update",
                                          @"controller":@"users"};
    // must convert the json data to NSObject
    NSData *jsonUserDetails = [NSJSONSerialization dataWithJSONObject:userDetails options:NSJSONWritingPrettyPrinted error:nil];
    // Create the request
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@", self.userID]];
    NSMutableURLRequest *patchRequest = [NSMutableURLRequest requestWithURL:url];
    // Specify that the request will be a PATCH
    patchRequest.HTTPMethod = @"PATCH";
    // Set the header fields
    [patchRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [patchRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // Not sure what happens here **** takes json and converts to string?? ******
    NSMutableString *stringData = [[NSMutableString alloc]initWithData:jsonUserDetails
                                                              encoding:NSUTF8StringEncoding];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    patchRequest.HTTPBody = requestBodyData;
    // Create URL connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:patchRequest delegate:self];
    conn = nil;
}

-(void)getRequest{
   
    self.userID = self.usernameTextField.text;
    // Create the request
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@.json", self.userID]];
    NSMutableURLRequest *patchRequest = [NSMutableURLRequest requestWithURL:url];
    // Specify that the request will be a GET
    patchRequest.HTTPMethod = @"GET";
    // Set the header fields
    [patchRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [patchRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // Create URL connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:patchRequest delegate:self];
    conn = nil;

}



#pragma mark - button actions
- (IBAction)createUser:(UIButton *)sender {
    [self postRequest];
}

- (IBAction)updateLocation:(UIButton *)sender {
    [self patchRequest];
}

- (IBAction)findChild:(UIButton *)sender {
   [self getRequest];
}
@end
