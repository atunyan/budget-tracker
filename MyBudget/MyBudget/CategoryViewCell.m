/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "CategoryViewCell.h"

@implementation CategoryViewCell
@synthesize category;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setData:(MOCategory*) _category {
    self.category = _category;
    self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    if (category != nil) {
        self.textLabel.text = NSLocalizedString(_category.name, nil);
        self.imageView.image = [UIImage imageNamed:category.categoryImageName];
    } else {
        self.textLabel.text = NSLocalizedString(@"Add new category", nil);
    }
}

-(void) dealloc {
    [category release];
    [super dealloc];
}

@end
