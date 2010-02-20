//
//  CPPassCodeView.m
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright 2010 . All rights reserved.
//

#import "CPLockController.h"

#define kCPLCDefaultSetPrompt			@"Enter your new passcode"
#define kCPLCDefaultAuthPrompt			@"Enter your passcode"

#define kCPLCDefaultSetTitle			@"Set Passcode"
#define kCPLCDefaultConfirmTitle		@"Confirm Passcode"
#define kCPLCDefaultAuthTitle			@"Enter Passcode"

#define kCPLCDefaultSetError			@"Passcodes did not match. Try again."
#define kCPLCDefaultAuthError			@"Passcode incorrect. Try again."

//private methods
@interface CPLockController()


- (void)setupSubviews;
- (void)setupNavigationBar;
- (void)setupTextFields;
- (void)resetFields;
- (void)passcodeDidNotMatch;
- (void)dissmissView;

@property (nonatomic, retain) NSMutableString *tempString;
@property (nonatomic) BOOL retry;
@property (nonatomic, retain) UILabel *promptLabel;
@property (nonatomic, retain) UILabel *subPromptLabel;
@property (nonatomic, retain) UITextField *hiddenField;
@property (nonatomic, retain) UINavigationItem *navigationItem;

@end






@implementation CPLockController
@synthesize delegate,style,passcode,prompt,hiddenField,navigationItem,promptLabel,subPromptLabel,tempString,retry,title,hideCode;

- (id)initWithStyle:(CPLockControllerStyle)theStyle {
	if(self = [super init]){
		self.style = theStyle;
		self.retry = NO;
		self.tempString = [NSMutableString string];
		self.hideCode = YES;
	}
	
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//needs a delegate
	assert(delegate != nil);
	
	//check if passcode is set for CPLockControllerTypeAuth
	if(style == CPLockControllerTypeAuth){
		assert(passcode != nil);
	}
	
	[self setupSubviews];
	
}

- (void)setupSubviews {

	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

	//prompt
	promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 85, 320, 25)];
	if(prompt == nil){
		if(self.style == CPLockControllerTypeSet){
			prompt = kCPLCDefaultSetPrompt;
		} else if(self.style == CPLockControllerTypeAuth){
			prompt = kCPLCDefaultAuthPrompt;
		} 
	}
	
	//main prompt
	promptLabel.text = prompt;
	promptLabel.textAlignment = UITextAlignmentCenter;
	promptLabel.backgroundColor = [UIColor clearColor];
	promptLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.50];
	promptLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    promptLabel.shadowOffset = CGSizeMake(0, -0.75);
	promptLabel.textColor = [UIColor colorWithRed:0.318 green:0.345 blue:0.416 alpha:1.000];	
	[self.view addSubview:promptLabel];

	//sub prompt- used for errors
	subPromptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, 320, 25)];
	subPromptLabel.textAlignment = UITextAlignmentCenter;
	subPromptLabel.backgroundColor = [UIColor clearColor];
	subPromptLabel.textColor = [UIColor colorWithRed:0.318 green:0.345 blue:0.416 alpha:1.000];;
	subPromptLabel.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:subPromptLabel];
	
	//bar
	[self setupNavigationBar];

	//text fields
	[self setupTextFields];
}

- (void)setupNavigationBar {
	
	UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,320,50)];
	navBar.barStyle = UIBarStyleBlack;
	[self.view addSubview:navBar];
	navigationItem = [[UINavigationItem alloc]init];

	[navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																		 target:self
																		 action:@selector(userDidCancel:)]
								 animated:NO];
	
	[navBar pushNavigationItem:navigationItem animated:NO];
	
	if(self.title == nil){
		if(self.style == CPLockControllerTypeSet){
			//[self setTitle:kCPLCDefaultSetTitle];
			navigationItem.title = kCPLCDefaultSetTitle;
		} else if(self.style == CPLockControllerTypeAuth){
			[self setTitle:kCPLCDefaultAuthTitle];
			navigationItem.title = kCPLCDefaultAuthTitle;
		}
	} else {
		navigationItem.title = title;
	}
								 
}

- (void)setupTextFields {
	int toppadding = 125;
	int leftpadding = 15;
	int width = 61;
	int height = 52;
	int padding = 15;
	CGFloat fontsize = 32;
	
	//create four textfields
	field1 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding,toppadding,width,height)];
	field1.backgroundColor = [UIColor whiteColor];
	field1.borderStyle = UITextBorderStyleBezel;
	//field1.enabled = NO;
	field1.secureTextEntry = self.hideCode;
	field1.font = [UIFont systemFontOfSize:fontsize];
	field1.textAlignment = UITextAlignmentCenter;
	field1.tag = 0;
	[self.view addSubview:field1];
	

	field2 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding+width+padding,toppadding,61,height)];
	field2.backgroundColor = [UIColor whiteColor];
	field2.borderStyle = UITextBorderStyleBezel;
	field2.enabled = NO;
	field2.secureTextEntry = self.hideCode;	
	field2.font = [UIFont systemFontOfSize:fontsize];	
	field2.textAlignment = UITextAlignmentCenter;
	field2.tag = 2;
	[self.view addSubview:field2];

	field3 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding+width*2+padding*2,toppadding,61,height)];
	field3.backgroundColor = [UIColor whiteColor];
	field3.borderStyle = UITextBorderStyleBezel;
	field3.enabled = NO;
	field3.secureTextEntry = self.hideCode;
	field3.font = [UIFont systemFontOfSize:fontsize];	
	field3.textAlignment = UITextAlignmentCenter;	
	field3.tag = 3;
	[self.view addSubview:field3];
	
	field4 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding+width*3+padding*3,toppadding,61,height)];
	field4.backgroundColor = [UIColor whiteColor];
	field4.borderStyle = UITextBorderStyleBezel;
	field4.enabled = NO;
	field4.secureTextEntry = self.hideCode;
	field4.font = [UIFont systemFontOfSize:fontsize];	
	field4.textAlignment = UITextAlignmentCenter;	
	field4.tag = 4;
	[self.view addSubview:field4];	
	
	//this is the field the passcode is put into
	hiddenField = [[UITextField alloc]initWithFrame:CGRectMake(-3000,-3000,0,0)];
	hiddenField.text = @"";
	hiddenField.keyboardType = UIKeyboardTypeNumberPad;
	[hiddenField becomeFirstResponder];
	hiddenField.delegate = self;	
	[self.view addSubview:hiddenField];
	
	

	
}

#pragma mark --
#pragma mark UITextFieldDelegate Method
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	int charcount = [textField.text length];

	if(self.retry == YES){
		charcount-=1;
	}
	
	if(charcount == 0){
		field1.text = string;
	} else if(charcount == 1){
		field2.text = string;
	} else if(charcount == 2){
		field3.text = string;
	} else if(charcount == 3){
		field4.text = string;
	} 
	[self.tempString appendString:string];

	//we've reached 4 chars
	if(charcount == 3){
		
		if(self.style == CPLockControllerTypeSet){
			
			if(passcode == nil){
				//empty tempstring to passcode string
				passcode = [self.tempString copy];

				self.tempString = [NSMutableString string];
								
				//reset visible/hidden fields
				[self resetFields];
				
				promptLabel.text = kCPLCDefaultConfirmTitle;
				self.retry = YES;
			} else {
				//check if confirm matches first
				if([passcode isEqualToString:self.tempString]){
					[delegate lockControllerDidFinish:passcode];
					[self dissmissView];

				//confirm passcode doesn't match
				} else {
					[self passcodeDidNotMatch];
				}
				
			}
			
		} else if(self.style == CPLockControllerTypeAuth){
				if([passcode isEqualToString:self.tempString]){
					[delegate lockControllerDidFinish:nil];
					[self dissmissView];				
					
				} else {
					[self passcodeDidNotMatch];
					
				}
			
			
		}
	}	
	
	return YES;
}

- (void)passcodeDidNotMatch {
	self.tempString = [NSMutableString string];
	if(self.style == CPLockControllerTypeSet){
		subPromptLabel.text = kCPLCDefaultSetError;
	} else if(self.style == CPLockControllerTypeAuth){
		subPromptLabel.text = kCPLCDefaultAuthError;	
	}
	self.retry = YES;
	[self resetFields];
}

- (void)resetFields {
	field1.text = @"";
	field2.text = @"";
	field3.text = @"";
	field4.text = @"";	
	hiddenField.text = @"";
}

- (void)dissmissView {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)userDidCancel:(id)sender {
	[delegate lockControllerDidCancel];
	[self dissmissView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
	[tempString release];
}


@end
