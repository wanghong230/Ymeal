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
@property(strong) NSString *rawJSON;
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
    self.rawJSON = [[NSString alloc] init];
    NSURL *url = [NSURL URLWithString:self.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            self.rawJSON  = (NSString *)JSON;
                                                                                            
                                                                                            NSLog([NSString stringWithFormat:@"%@", self.rawJSON]);
                                                                                        }
                                         
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"error response");
                                                                                        }];
    
    [operation start];
    
    //NSObject *meals = [NSJSONSerialization JSONObjectWithData:self.rawJSON options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"meals.count:%d", [meals count]);
    
    //NSData *data = [self.rawJSON dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"lalala");
    /*
    if (data == nil) {
        
        NSLog(@"null");
    }
    NSError *e;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:self.rawJSON options:NSJSONReadingMutableContainers error:&e];
    //NSLog(@"array count: %d", [array count]);
     */
    return cafeToMealsMap;
}


@end
