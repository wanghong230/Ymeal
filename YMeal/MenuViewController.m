//
//  MenuViewController.m
//  YMeal
//
//  Created by Hong Wang on 8/12/13.
//
//

#import "MenuViewController.h"
#import "CustomCell.h"
#import <AFJSONRequestOperation.h>
#import "MealObject.h"

@interface MenuViewController ()

@property(nonatomic, strong) NSMutableDictionary *cafeToMealsMap;
@property(nonatomic, strong) NSMutableArray *mealsArray;
@property(nonatomic, strong) NSString *baseurl;
@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.mealsArray = [[NSMutableArray alloc] init];
        self.cafeToMealsMap = [[NSMutableDictionary alloc] init];
        self.baseurl = @"http://ec2-50-19-203-2.compute-1.amazonaws.com/api/meal";
        //NSLog(@"count: %d", [self.mealsArray count]);

        [self refreshMeals];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *customNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"CustomCell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // fetching data
    
    [self refreshMeals];

    
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
     // Need to know how many different sections today for Qian Long
    return [[self.cafeToMealsMap allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // Need to know how many different meals today for Qian Long
    return [self.mealsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

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
    //MealObject *meal = [self.mealsArray objectAtIndex:indexPath.row];
    
    if (indexPath.row < [self.mealsArray count]) {
        MealObject *meal = [self.mealsArray objectAtIndex:indexPath.row];
        cell.category.text = [meal name];
        cell.menuname.text = [meal name];
    }
    else {
        cell.category.text = @"WUT";
        cell.menuname.text = @"WUT";
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section < [[self.cafeToMealsMap allKeys] count]) {
        return (NSString *)[[self.cafeToMealsMap allKeys] objectAtIndex:section];
    }
    else {
        return @"WUT";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    if (section < [[self.cafeToMealsMap allKeys] count]) {
        return (NSString *)[[self.cafeToMealsMap allKeys] objectAtIndex:section];
    }
    else {
        return @"WUT";
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
    NSLog(@"The section:%d The row:%d", indexPath.section, indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
//    if (indexPath.section == 0) {
//        if (indexPath.row == 1) {
//            return 90;
//        }
//    }
    return 90;
}


#pragma mark - communication to backend
- (void) refreshMeals {
    NSLog(@"in refreshMeals");
    NSURL *url = [NSURL URLWithString:self.baseurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //self.mealsArray = [[NSMutableArray alloc] init];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSData *jsonData = (NSData *)JSON;  
            NSArray *jsonArray = (NSArray *)jsonData;
            
            // create new objects and throw away old
            self.mealsArray = [[NSMutableArray alloc] init];
            self.cafeToMealsMap = [[NSMutableDictionary alloc] init];
            
            // populating self.mealsArray
            for (id obj in jsonArray) {
                NSDictionary *dict = (NSDictionary *)obj;
                MealObject *meal = [[MealObject alloc] init];
                                                                                          
                meal.mealID = (NSNumber *)[dict objectForKey:@"id"];
                meal.description = (NSString *)[dict objectForKey:@"description"];
                meal.dateStr = (NSString *)[dict objectForKey:@"date"];
                meal.cafeteria = (NSString *) [dict objectForKey:@"cafeteria"];
                meal.name = (NSString *) [dict objectForKey:@"name"];
                [self.mealsArray addObject:meal];
            }
            for (MealObject *meal in self.mealsArray) {
                NSLog([meal name]);
            }
            
            // populating self.cafeToMealsMap
            for (MealObject *meal in self.mealsArray) {
                if (![self.cafeToMealsMap objectForKey: meal.cafeteria]) {
                    NSLog(@"%@ not in dict", meal.cafeteria);
                    NSMutableArray *cafeMealsArray = [[NSMutableArray alloc] init];
                    [self.cafeToMealsMap setObject:cafeMealsArray forKey:meal.cafeteria];
                }
                
                [[self.cafeToMealsMap objectForKey:meal.cafeteria] addObject:meal];
                
            }
            
            [self.tableView reloadData];
        }
                                        
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error response");
        }];
    
    [operation start];

}
@end
