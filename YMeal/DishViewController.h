//
//  DishViewController.h
//  YahooMeal
//
//  Created by Hong  Wang on 8/15/13.
//  Copyright (c) 2013 Hong  Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishViewController : UIViewController {
    int rowSelectedPreviously;
    int sectionSelectedPreviously;
    
}
@property (nonatomic, weak) IBOutlet UILabel *description;
@property (nonatomic) int rowSelectedPreviously;
@property (nonatomic) int sectionSelectedPreviously;

@end
