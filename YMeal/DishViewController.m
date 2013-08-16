//
//  DishViewController.m
//  YahooMeal
//
//  Created by Hong  Wang on 8/15/13.
//  Copyright (c) 2013 Hong  Wang. All rights reserved.
//

#import "DishViewController.h"

@interface DishViewController ()

@end

@implementation DishViewController

@synthesize rowSelectedPreviously;
@synthesize sectionSelectedPreviously;
@synthesize meal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.title = @"Dish";
        
        // Use meal oject to set things here
        
//        self.numOfLike =
//        self.numOfDislike = 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.]
    /*
    if(rowSelectedPreviously == 0) {
        self.description.text = @"IOS hard to use";
    } else {
        self.description.text = @"Maybe Android is good";
    }
     */
    self.description.text = self.meal.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
