//
//  CustomCell.h
//  YMeal
//
//  Created by Hong Wang on 8/12/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *category;
@property (nonatomic, weak) IBOutlet UILabel *menuname;
@property (nonatomic, weak) IBOutlet UIButton *like;
@property (nonatomic, weak) IBOutlet UIButton *dislike;

@end
