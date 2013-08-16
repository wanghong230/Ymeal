//
//  ClientManager.h
//  YMeal
//
//  Created by Qian  Long on 8/15/13.
//
//  Client Manager for communicating with the backend api
//  Should be used as a singleton/static class
//  all class methods

#import <Foundation/Foundation.h>

@interface ClientManager : NSObject

- (id)init;
- (NSDictionary *) getMeals;

//+(void *) postLikeMeal:(NSInteger *) mealId;
//+(void *) postDislikeMeal:(NSInteger *) mealId;
//+(NSDictionary *) postComment;
//+(NSDictionary *) getComments;
@end
