//
//  ClientManager.m
//  YMeal
//
//  Created by Qian  Long on 8/15/13.
//
//

#import "ClientManager.h"
#import <AFJSONRequestOperation.h>
#import "MealObject.h"
@interface ClientManager()
@property(strong) NSString *rawJSON;
@property(strong) NSString *baseURL;
@property(strong) NSData *data;
@property(strong) NSArray *meals;
@end


@implementation ClientManager
- (id) init {
    self = [super init];
    if (self) {
        // initialize stuff
        self.data = [[NSData alloc] init];
        self.baseURL = @"http://ec2-50-19-203-2.compute-1.amazonaws.com/api/meal";
    }
    return self;
}

- (void) getMeals {
    NSArray *meals = [[NSArray alloc] init];
    // string to array of mealobjects
    NSDictionary* cafeToMealsMap = [[NSDictionary alloc] init];
    self.rawJSON = [[NSString alloc] init];
    self.data = [[NSData alloc] init];
    NSURL *url = [NSURL URLWithString:self.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                            NSData *jsonData = (NSData *)JSON;
                                            if ([NSJSONSerialization isValidJSONObject: jsonData]) {
                                                NSLog(@"valid json");
                                            }
                                            else {
                                                NSLog(@"not valid json");
                                            }
                                            NSArray *jsonArray = (NSArray *)jsonData;
                                            NSLog(@"count: %d", [jsonArray count]);
                                            
                                            NSMutableArray* array = [[NSMutableArray alloc] init];
                                            for (id obj in jsonArray) {
                                                NSDictionary *dict = (NSDictionary *)obj;
                                                MealObject *meal = [[MealObject alloc] init];
                                                /*
                                                NSLog(@"%@", (NSString *)[dict objectForKey: @"name"]);
                                                NSLog(@"%@", (NSString *)[dict objectForKey: @"description"]);
                                                NSLog(@"%@", (NSString *)[dict objectForKey: @"date"]);
                                                NSLog(@"%@", (NSString *)[dict objectForKey: @"cafeteria"]);
                                                NSLog(@"id: %@", (NSNumber *)[dict objectForKey: @"id"]);
                                                 */
                                                meal.mealID = (NSNumber *)[dict objectForKey:@"id"];
                                                meal.description = (NSString *)[dict objectForKey:@"description"];
                                                meal.dateStr = (NSString *)[dict objectForKey:@"date"];
                                                meal.cafeteria = (NSString *) [dict objectForKey:@"cafeteria"];
                                                meal.name = (NSString *) [dict objectForKey:@"name"];
                                                //NSLog([meal toString]);
                                                [array addObject:meal];
                                            }
                                            
                                            for (MealObject *meal in array) {
                                                NSLog([meal name]);
                                            }
                                        }
                                         
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                            NSLog(@"error response");
                                        }];
    
    [operation start];
    return;
}


@end
