//
//  TestViewController.m
//  YMeal
//
//  Created by Qian  Long on 8/12/13.
//
//

#import "TestViewController.h"
#import "TraktAPIClient.h"
#import <AFNetworking.h>
@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // 1 - Create trakt API client
    TraktAPIClient* client = [TraktAPIClient sharedClient];
    // 2 - Create date instance with today's date
    NSDate* today = [NSDate date];
    // 3 - Create date formatter
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString* todayString = [formatter stringFromDate:today];
    // 4 - Create API query request
    NSString* path = [NSString stringWithFormat:@"user/calendar/shows.json/%@/%@/%@/%d", kTraktAPIKey, @"marcelofabri", todayString, 3];
    NSURLRequest* request = [client requestWithMethod:@"GET" path:path parameters:nil];
    // 5 - Create JSON request operation
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // 6 - Request succeeded block
        NSLog(@"%@", JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // 7 - Request failed block
    }];
    // 8 - Start request
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
