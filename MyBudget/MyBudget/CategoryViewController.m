/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "CategoryViewController.h"
#import "Constants.h"
#import "MOCategory.h"
#import "UserInfo.h"
#import "CoreDataManager.h"
#import "MOUser.h"

#import <QuartzCore/QuartzCore.h>

///tag for  category  name  text field
#define  CATEGORY_NAME_TAG      2001

///tag for  category  icon view
#define  ICON_VIEW_TAG          2002

///tag for  PickerView  control
#define  PICKER_VIEW_TAG        2003

///tag for  PickerView  control
#define  SCROLL_VIEW_TAG        2004


@implementation CategoryViewController

@synthesize currentImageName;
@synthesize delegate;

-(id)initWithParentCategory:(MOCategory*)category {
    self = [super init];
    if (self) {
        parentCategory = [category retain];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)saveButtonClicked:(id) sender {
    UITextField* textField = (UITextField*)[self.view viewWithTag:CATEGORY_NAME_TAG];
    NSString * categoryName = textField.text;
    categoryName = [categoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (currentImageName && categoryName && ![categoryName isEqualToString:@""]  ) {
        MOCategory* category = [[CoreDataManager instance] category];        
        category.name = categoryName;
        category.parentCategory = parentCategory;
        if (!parentCategory) {
            category.user = [MOUser instance];
            [[MOUser instance].categories addObject:category];
        }
        category.categoryImageName = [ROOT_CATEGORY_DIR stringByAppendingPathComponent:currentImageName];
    
        if ([delegate respondsToSelector:@selector(addNewCategory:)]) {
            [delegate addNewCategory:category];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please fill in category name and/or choose icon", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
        [alert release];
    }
}

-(void) createPickerView {
    
    IconPicker* picker =  [[IconPicker alloc] initWithFrame:CGRectMake(8, 75, 305, 250)];
    picker.backgroundColor = [UIColor whiteColor];
    
    NSArray* imageArray = [CoreDataManager imageNameArray];
    [picker setIcons:imageArray];
    picker.tag = PICKER_VIEW_TAG;
    picker.layer.cornerRadius = 8;
    picker.iconPickerDelegate = self;
    [self.view addSubview:picker];
    [picker release];    
}

-(void) createCategoryNameField {
    UITextField*  textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 20, 245, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.tag = CATEGORY_NAME_TAG;
    textField.backgroundColor =  [UIColor  whiteColor];
    textField.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0f];
    textField.layer.masksToBounds = NO;
    textField.layer.cornerRadius = 8; 
    textField.delegate = self;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = NSLocalizedString(@"Please fill in category name", nil);
    [self.view  addSubview:textField];
    [textField release];    
}

-(void) createIconView {
    UIImageView*  iconView =  [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    iconView.tag = ICON_VIEW_TAG;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.clipsToBounds = YES;
    iconView.layer.cornerRadius = 8; 
    [self.view  addSubview:iconView];
    [iconView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];

    [self createPickerView];
    [self createCategoryNameField];
    [self createIconView];
   
    UIBarButtonItem* saveItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = saveItem;
}

-(void)keyboardWillShow:(NSNotification *)aNotification {
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    IconPicker*  picker = (IconPicker*)[self.view viewWithTag:PICKER_VIEW_TAG];
    picker.frame = CGRectMake(picker.frame.origin.x, picker.frame.origin.y, picker.frame.size.width,picker.frame.size.height - 137);
    [picker setContentSize:CGSizeMake(picker.frame.size.width, picker.frame.size.height + keyboardRect.size.height)];
}


-(void)keyboardWillHide:(NSNotification *)aNotification {
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    IconPicker*  picker = (IconPicker*)[self.view viewWithTag:PICKER_VIEW_TAG];
    picker.frame = CGRectMake(picker.frame.origin.x, picker.frame.origin.y, picker.frame.size.width,picker.frame.size.height + 137);
   [picker setContentSize:CGSizeMake(picker.frame.size.width, picker.frame.size.height - keyboardRect.size.height)];
  
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    IconPicker*  picker = (IconPicker*)[self.view viewWithTag:PICKER_VIEW_TAG];
    UITextField*  textView = (UITextField*) [self.view viewWithTag:CATEGORY_NAME_TAG];
    UIImageView*  imageView = (UIImageView*)[self.view viewWithTag:ICON_VIEW_TAG];
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        picker.frame = CGRectMake(20, 100, 280, 300);
        textView.frame = CGRectMake(70, 20, 230, 40);
        imageView.frame = CGRectMake(20, 20, 30, 30);
        
    } else  { 
        picker.frame = CGRectMake(20, 100, 440, 140);
        textView.frame = CGRectMake(70, 20, 390, 40);
        imageView.frame = CGRectMake(20, 20, 30, 30);
    }
    
    [picker updateFrames:toInterfaceOrientation];
    
}

-(void) setIcon:(NSString *)imageName {
    self.currentImageName = imageName;
    UIImageView*  imageView = (UIImageView*)[self.view viewWithTag:ICON_VIEW_TAG];
    [imageView setImage:[UIImage imageNamed:[ROOT_CATEGORY_DIR stringByAppendingPathComponent:imageName]]];
     UITextField*  textView = (UITextField*) [self.view viewWithTag:CATEGORY_NAME_TAG];
    [textView resignFirstResponder];
}


#pragma Text Field delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Set text fields max text length
    if (textField.tag == CATEGORY_NAME_TAG) {
        if (range.location >= 25) {
            return NO;
        }
    }
    NSString* currentText = textField.text;
    if ([string isEqualToString:@" "]) {
        // Is it first symbol
        if ([currentText length] == 0) {
            return NO;
        }
    }
    return YES;
}


-(void) dealloc {
    [parentCategory release];
    [currentImageName release];
    [super dealloc];
}

@end
