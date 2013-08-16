//
//  MealObject.h
//  YMeal
//
//  Created by Qian  Long on 8/15/13.
//
//

#import <Foundation/Foundation.h>

@interface MealObject : NSObject

@property (nonatomic, strong, readonly) NSString *mealID;
@property (nonatomic, strong, readonly) NSString *dateStr;
@property (nonatomic, strong, readonly) NSString *cafeteria;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong) NSArray *attributes;

@end
