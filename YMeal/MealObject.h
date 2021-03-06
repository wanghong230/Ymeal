//
//  MealObject.h
//  YMeal
//
//  Created by Qian  Long on 8/15/13.
//
//

#import <Foundation/Foundation.h>

@interface MealObject : NSObject

@property (nonatomic, strong) NSNumber *mealID;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *cafeteria;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *category;
// "breakfast", "lunch", "dinner"
@property (nonatomic, strong) NSString *bld;
// "none", "like", "dislike"
@property (nonatomic, strong) NSString *voted;
@property int numLikes;
@property int numDislikes;
//@property (nonatomic, strong) NSArray *attributes;

@end
