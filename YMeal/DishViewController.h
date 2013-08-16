//
//  DishViewController.h
//  YahooMeal
//
//  Created by Hong  Wang on 8/15/13.
//  Copyright (c) 2013 Hong  Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealObject.h"

@interface DishViewController : UIViewController {
    int rowSelectedPreviously;
    int sectionSelectedPreviously;
    
}
@property (nonatomic, weak) IBOutlet UILabel *description;
@property (nonatomic, weak) IBOutlet UILabel *numOfLike;
@property (nonatomic, weak) IBOutlet UILabel *numOfDislike;
@property (nonatomic) int rowSelectedPreviously;
@property (nonatomic) int sectionSelectedPreviously;
@property (nonatomic, weak) MealObject *meal;

@end
