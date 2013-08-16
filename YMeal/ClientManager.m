//
//  ClientManager.m
//  YMeal
//
//  Created by Qian  Long on 8/15/13.
//
//

#import "ClientManager.h"
#import <AFJSONRequestOperation.h>

@interface ClientManager()
@property(strong) NSDictionary *rawJSON;
@property(strong) NSString *baseURL;
@end


@implementation ClientManager
- (id) init {
    self = [super init];
    if (self) {
        // initialize stuff
        self.baseURL = @"http://ec2-50-19-203-2.compute-1.amazonaws.com/api/meal";
    }
    return self;
}

- (NSDictionary *) getMeals {
    // string to array of mealobjects
    NSDictionary* cafeToMealsMap = [[NSDictionary alloc] init];
    //NSDictionary* rawJSON = [[NSDictionary alloc] init];
    self.rawJSON = [[NSDictionary alloc] init];
    //test networking stuff
    NSURL *url = [NSURL URLWithString:self.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            self.rawJSON  = (NSDictionary *)JSON;
                                                                                            
                                                                                            NSLog([NSString stringWithFormat:@"%@", [self.rawJSON description]]);
                                                                                        }
                                         
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"error response");
                                                                                        }];
    
    [operation start];
    
    return cafeToMealsMap;
}


@end
