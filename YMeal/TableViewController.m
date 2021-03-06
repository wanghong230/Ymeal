//
//  TableViewController.m
//  YahooMeal
//
//  Created by Hong  Wang on 8/16/13.
//  Copyright (c) 2013 Hong  Wang. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"
#import "DishViewController.h"
#import <AFJSONRequestOperation.h>
#import <AFHTTPClient.h>
#import "MealObject.h"

@interface TableViewController ()

@property(nonatomic, strong) NSMutableDictionary *cafeToMealsMap;
@property(nonatomic, strong) NSMutableArray *mealsArray;
@property(nonatomic, strong) NSString *baseurl;
@property(nonatomic, strong) NSString *deviceID;
@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.mealsArray = [[NSMutableArray alloc] init];
        self.cafeToMealsMap = [[NSMutableDictionary alloc] init];
        self.baseurl = @"http://ec2-50-19-203-2.compute-1.amazonaws.com/api/";
        self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"Yahoo! Meal";
    UINib *customNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"CustomCell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // fetching data
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshMeals)];
                                      
                                      
                                      //initWithTitle:nil style:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPropertyList:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self refreshMeals];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
//    refreshControl.tintColor = [UIColormagentaColor];
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)changeSorting
{
     [self refreshMeals];
     [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [[self.cafeToMealsMap allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *key = [[self.cafeToMealsMap allKeys] objectAtIndex:section];
    NSArray *cafeMeals = [self.cafeToMealsMap objectForKey:key];
    return [cafeMeals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIndetifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifier];
    if(cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndetifier];
    }
    
    cell.like.tag = indexPath.section * 1000 + indexPath.row;
    [cell.like addTarget:self action:@selector(onTouchLike:) forControlEvents:UIControlEventTouchDown];
    cell.dislike.tag = indexPath.section * 1000 + indexPath.row + 10000;
    [cell.dislike addTarget:self action:@selector(onTouchDislike:) forControlEvents:UIControlEventTouchDown];
    
//    CustomCell *cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndetifier];
    
    // Configure the cell...
    /*
    if(indexPath.row == 0) {
        cell.category.text = @"Pizza Special";
        cell.menuname.text = @"Roasted fig and prosciutto";
    } else if (indexPath.row == 1) {
        cell.category.text = @"market grill";
        cell.menuname.text = @"Diestel Ranch turkey burger";
    } else if (indexPath.row == 2) {
        cell.category.text = @"classics";
        cell.menuname.text = @"roasted Cajun spice chicken";
    } else {
        cell.category.text = @"stir-fry";
        cell.menuname.text = @"lemon chicken ";
    }
    */
    
    NSString *key = [[self.cafeToMealsMap allKeys] objectAtIndex:indexPath.section];
    NSArray *cafeMeals = [self.cafeToMealsMap objectForKey:key];

    if (indexPath.row < [cafeMeals count]) {
        MealObject *meal = [cafeMeals objectAtIndex:indexPath.row];
        cell.category.text = [[meal category] uppercaseString];
        cell.menuname.text = [meal name];
        NSString *likeText = [NSString stringWithFormat:@"Like(%d)", [meal numLikes]];
        NSString *dislikeText = [NSString stringWithFormat:@"Dislike(%d)", [meal numDislikes]];
        [cell.like setTitle:likeText forState:UIControlStateNormal];
        [cell.dislike setTitle:dislikeText forState:UIControlStateNormal];
        
        // meal.voted = "none", "dislike", "like"
        
        if ([meal.voted isEqualToString: @"like"]) {
            [self onTouchLikeFake: cell.like];
        }
        else if ([meal.voted isEqualToString: @"dislike"]) {
            [self onTouchDislikeFake: cell.dislike];
        }
        
    }
    else {
        cell.category.text = @"WUT";
        cell.menuname.text = @"WUT";
    }
    
    UIColor * color1 = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    UIColor * color2 = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    UIColor * color3 = [UIColor colorWithRed:80/255.0f green:0/255.0f blue:134/255.0f alpha:1.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row % 2)
    {
        [cell.contentView setBackgroundColor:color2];
        [cell.accessoryView setBackgroundColor:color2];
        [cell.menuname setTextColor:[UIColor blackColor]];
        [cell.category  setTextColor:[UIColor blackColor]];
        [cell.like setBackgroundColor:color3];
        [cell.dislike setBackgroundColor:color3];
    } else {
        [cell.contentView setBackgroundColor:color2];
        [cell.accessoryView setBackgroundColor:color2];
        [cell.menuname setTextColor:[UIColor blackColor]];
        [cell.category  setTextColor:[UIColor blackColor]];
        [cell.like setBackgroundColor:color3];
        [cell.dislike setBackgroundColor:color3];
//        [cell.menuname set]
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIColor * color1 = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    UIColor * color2 = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
//    UIColor * color1 = [UIColor colorWithRed:254/255.0f green:220/255.0f blue:58/255.0f alpha:1.0f];
//    UIColor * color2 = [UIColor colorWithRed:98/255.0f green:0/255.0f blue:139/255.0f alpha:1.0f];
//    UIColor * color2 = [UIColor colorWithRed:151/255.0f green:141/255.0f blue:124/255.0f alpha:1.0f];
    
    if (indexPath.row % 2)
    {
        cell.backgroundColor = color2;
    } else {
        cell.backgroundColor = color2;
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return[NSArray arrayWithObjects:@"U", @"E", @"B", @"G",nil];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if([title isEqualToString:@"U"]) {
        return 0;
    } else if ([title isEqualToString:@"E"]) {
        return 1;
    } else if ([title isEqualToString:@"B"]) {
        return 2;
    } else if ([title isEqualToString:@"G"]) {
        return 3;
    } else {
        return 4;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    DishViewController *dish = [[DishViewController alloc] init];
    dish.rowSelectedPreviously = indexPath.row;
    dish.sectionSelectedPreviously = indexPath.section;
    // set dish
    NSString *key = [[self.cafeToMealsMap allKeys] objectAtIndex:indexPath.section];

    NSLog(@"section selected: %d, row selected: %d, key: %@, allKeys count: %d", indexPath.section, indexPath.row, key, [[self.cafeToMealsMap allKeys] count]);
    NSArray *cafeMeals = [self.cafeToMealsMap objectForKey:key];
    NSLog(@"array size: %d", [cafeMeals count]);
    MealObject *meal = [[self.cafeToMealsMap objectForKey:key] objectAtIndex:indexPath.row];
    dish.meal = meal;
    [self.navigationController pushViewController:dish animated:TRUE];
    NSLog(@"The section:%d The row:%d", indexPath.section, indexPath.row);
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section < [[self.cafeToMealsMap allKeys] count]) {
//        return (NSString *)[[self.cafeToMealsMap allKeys] objectAtIndex:section];
//    }
//    
//    
//    return @"WUT";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
//    [lbl.superview setFrame:CGRectMake(50, 50, lbl.frame.size.width, lbl.frame.size.height)];
    
    UIColor * color1 = [UIColor colorWithRed:98/255.0f green:0/255.0f blue:139/255.0f alpha:1.0f];
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = color1;
    lbl.shadowColor = color1;
    lbl.shadowOffset = CGSizeMake(0,1);
//    lbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my_head_bg"]];
    lbl.alpha = 0.9;
    
    if (section < [[self.cafeToMealsMap allKeys] count]) {
        lbl.text = [(NSString *)[[self.cafeToMealsMap allKeys] objectAtIndex:section] uppercaseString];
    }
    return lbl;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
    
}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    if (section < [[self.cafeToMealsMap allKeys] count]) {
//        return (NSString *)[[self.cafeToMealsMap allKeys] objectAtIndex:section];
//    }
//    return @"WUT";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 100;
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
////    if (section == integerRepresentingYourSectionOfInterest)
//        [headerView setBackgroundColor:[UIColor redColor]];
////    else
////        [headerView setBackgroundColor:[UIColor clearColor]];
//    
//    
//    return headerView;
//}

//- (void) onLikeButton:(UIButton *)likeButton {
//    NSLog(@"Like Pushed");
//    likeButton.
//
//    [likeButton setHighlighted:YES];
////    [likeButton setSelected:TRUE];
//}
//
//- (void) onDislikeButton:(UIButton *)dislikeButton {
//    NSLog(@"Dislike Pushed");
//    [dislikeButton setHighlighted:TRUE];
//}

- (void)highlightButton:(UIButton *)b {
    [b setHighlighted:YES];
}

- (IBAction)onTouchLike:(UIButton *)sender {
    NSLog(@"AAAA %d", sender.tag);

    [sender setBackgroundColor:[UIColor grayColor]];
    [sender setEnabled:FALSE];
    CustomCell *cell = (CustomCell *)[[sender superview] superview];
    UIButton *dislikeButton = cell.dislike;
    [dislikeButton setEnabled:FALSE];
    // send post request to backend
    [self postLikeMeal:sender.tag];
    
    //increment UI by 1;
    int sectionInt = (sender.tag % 10000) / 1000;
    int rowInt = sender.tag % 1000;
    NSString *key = [[self.cafeToMealsMap allKeys] objectAtIndex:sectionInt];
    MealObject *meal = [[self.cafeToMealsMap objectForKey:key] objectAtIndex: rowInt];
    
    NSString *likeText = [NSString stringWithFormat:@"Like(%d)", [meal numLikes]];
    [sender setTitle:likeText forState:UIControlStateNormal];
    
    
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}

- (IBAction)onTouchDislike:(UIButton *)sender {
    NSLog(@"BBB %d", sender.tag);
    [sender setBackgroundColor:[UIColor grayColor]];
    [sender setEnabled:FALSE];
    CustomCell *cell = (CustomCell *)[[sender superview] superview];
    UIButton *likeButton = cell.like;
    [likeButton setEnabled:FALSE];
    
    // send post request to backend
    [self postDislikeMeal:sender.tag];
    
    //increment UI by 1;
    int sectionInt = (sender.tag % 10000) / 1000;
    int rowInt = sender.tag % 1000;
    NSString *key = [[self.cafeToMealsMap allKeys] objectAtIndex:sectionInt];
    MealObject *meal = [[self.cafeToMealsMap objectForKey:key] objectAtIndex: rowInt];
    
    NSString *dislikeText = [NSString stringWithFormat:@"Dislike(%d)", [meal numDislikes]];
    [sender setTitle:dislikeText forState:UIControlStateNormal];
    
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}

- (IBAction)onTouchLikeFake:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor grayColor]];
    [sender setEnabled:FALSE];
    CustomCell *cell = (CustomCell *)[[sender superview] superview];
    UIButton *dislikeButton = cell.dislike;
    [dislikeButton setEnabled:FALSE];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}

- (IBAction)onTouchDislikeFake:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor grayColor]];
    [sender setEnabled:FALSE];
    CustomCell *cell = (CustomCell *)[[sender superview] superview];
    UIButton *likeButton = cell.like;
    [likeButton setEnabled:FALSE];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}

#pragma mark - communication to backend
- (void) refreshMeals {
    NSLog(@"in refreshMeals");
    NSString *mealsURL = [self.baseurl stringByAppendingString:@"meals"];
    //NSLog(@"mealsURL %@", mealsURL);
    NSURL *url = [NSURL URLWithString:[self.baseurl stringByAppendingString:@"meals"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:@{@"deviceid": self.deviceID}];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                           NSData *jsonData = (NSData *)JSON;
                                                                                           NSArray *jsonArray = (NSArray *)jsonData;
                                                                                           
                                                                                           // create new objects and throw away old
                                                                                           self.mealsArray = [[NSMutableArray alloc] init];
                                                                                           self.cafeToMealsMap = [[NSMutableDictionary alloc] init];
                                                                                           NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
                                                                                           
                                                                                           // populating self.mealsArray
                                                                                           for (id obj in jsonArray) {
                                                                                               NSDictionary *dict = (NSDictionary *)obj;
                                                                                               MealObject *meal = [[MealObject alloc] init];
                                                                                               
                                                                                               meal.mealID = (NSNumber *)[dict objectForKey:@"meal_id"];
                                                                                               meal.description = (NSString *)[dict objectForKey:@"description"];
                                                                                               meal.dateStr = (NSString *)[dict objectForKey:@"date"];
                                                                                               meal.cafeteria = (NSString *) [dict objectForKey:@"cafeteria"];
                                                                                               meal.name = (NSString *) [dict objectForKey:@"name"];
                                                                                               meal.category = (NSString *) [dict objectForKey:@"category"];
                                                                                               meal.bld = (NSString *) [dict objectForKey:@"bld"];
                                                                                               meal.voted = @"none";
                                                                                               meal.numLikes = arc4random() % 100;
                                                                                               meal.numDislikes = arc4random() %100;
                                                                                               [tmpArray addObject:meal];
                                                                                           }
                                                                                           for (MealObject *meal in self.mealsArray) {
                                                                                               NSLog([meal name]);
                                                                                           }
                                                                                           
                                                                                           // filter conditions
                                                                                           NSDate *today = [NSDate date];
                                                                                           //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                                                           NSCalendar *calendar = [NSCalendar currentCalendar];
                                                                                           NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
                                                                                           NSInteger hour = [components hour];
                                                                                           NSLog(@"current hour: %d", hour);
                                                                                           // filter by time of day only display upcoming meals
                                                                                           for (MealObject *meal in tmpArray) {
                                                                                               if (hour < 11) {
                                                                                                   //breakfast
                                                                                                   if ([meal.bld isEqualToString:@"breakfast"]) {
                                                                                                       [self.mealsArray addObject:meal];
                                                                                                   }
                                                                                               }
                                                                                               else if (hour < 16) {
                                                                                                   //lunch
                                                                                                   if ([meal.bld isEqualToString:@"lunch"]) {
                                                                                                       [self.mealsArray addObject:meal];
                                                                                                   }
                                                                                               }
                                                                                               else {
                                                                                                   //dinner
                                                                                                   if ([meal.bld isEqualToString:@"dinner"]) {
                                                                                                       [self.mealsArray addObject:meal];
                                                                                                   }
                                                                                               }
                                                                                           }
                                                                                           NSLog(@"total meals: %d", [tmpArray count]);
                                                                                           NSLog(@"current meals: %d", [self.mealsArray count]);
                                                                                           // populating self.cafeToMealsMap
                                                                                           for (MealObject *meal in self.mealsArray) {
                                                                                               if (![self.cafeToMealsMap objectForKey: meal.cafeteria]) {
                                                                                                   NSMutableArray *cafeMealsArray = [[NSMutableArray alloc] init];
                                                                                                   [self.cafeToMealsMap setObject:cafeMealsArray forKey:meal.cafeteria];
                                                                                               }
                                                                                               
                                                                                               [[self.cafeToMealsMap objectForKey:meal.cafeteria] addObject:meal];
                                                                                               
                                                                                           }
                                                                                           
                                                                                           //sort each array by numlikes, then alpha
                                                                                           NSArray *keys = [self.cafeToMealsMap allKeys];
                                                                                           
                                                                                           for (NSString *key in keys) {
                                                                                               NSMutableArray *cafeArray = [self.cafeToMealsMap objectForKey:key];
                                                                                               NSSortDescriptor *byLike = [[NSSortDescriptor alloc] initWithKey:@"numLikes" ascending:NO];
                                                                                               NSSortDescriptor *byName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                                                                                               
                                                                                               
                                                                                               [cafeArray sortUsingDescriptors:[NSArray arrayWithObjects:byLike, byName, nil]];
                                                                                              
                                                                                          
                                                                                           }
                                                                                           //
                                                                                           [self.tableView reloadData];
                                                                                       }
                                        
                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                           NSLog(@"error response");
                                                                                       }];
    
    [operation start];
    
}

-(void) postLikeMeal:(int)encodedTag {
    NSLog(@"in postLikeMeal");
    
    int sectionInt = (encodedTag % 10000) / 1000;
    int rowInt = encodedTag % 1000;
    
    NSString *key = [[self.cafeToMealsMap allKeys] objectAtIndex:sectionInt];
    MealObject *meal = [[self.cafeToMealsMap objectForKey:key] objectAtIndex: rowInt];
    NSString *listURLpostfix = [NSString stringWithFormat:@"%d/like", meal.mealID];
    NSString *likeURL = [self.baseurl stringByAppendingString:listURLpostfix];
    
    NSLog(@"likeURL: %@", likeURL);
    NSURL *url = [NSURL URLWithString:likeURL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];    
    
    //TODO move
    meal.numLikes = meal.numLikes + 1;
    meal.voted = @"like";
    //[self.tableView reloadData];
    
    NSLog(meal.name);
    NSString *mealid = [meal.mealID stringValue];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:@{@"deviceid": self.deviceID, @"mealid": mealid}];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"successful like post");
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error response");
        }];
    [operation start];
}

-(void) postDislikeMeal:(int)encodedTag {
    NSLog(@"in postDISLIKEMeal");
    int sectionInt = (encodedTag % 10000) / 1000;
    int rowInt = encodedTag % 1000;
    NSString *key = [[self.cafeToMealsMap allKeys] objectAtIndex:sectionInt];
    MealObject *meal = [[self.cafeToMealsMap objectForKey:key] objectAtIndex: rowInt];
    
    NSString *dislikeURLpostfix = [NSString stringWithFormat:@"%d/dislike", meal.mealID];
    NSString *dislikeURL = [self.baseurl stringByAppendingString:dislikeURLpostfix];
    NSLog(@"dislikeURL: %@", dislikeURL);

    NSURL *url = [NSURL URLWithString:dislikeURL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];

    
    //TODO move to success
    meal.numDislikes = meal.numDislikes + 1;
    meal.voted = @"dislike";
    
    NSLog(meal.name);
    NSString *mealid = [meal.mealID stringValue];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:@{@"deviceid": self.deviceID, @"mealid": mealid}];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                           NSLog(@"successful like post");
                                                                                       }
                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                           NSLog(@"error response");
                                                                                       }];
    [operation start];
}
@end
