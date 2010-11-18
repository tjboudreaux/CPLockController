//
//  CPPassCodeView.h
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright 2010 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
CPLockControllerTypeAuth,
CPLockControllerTypeSet
} CPLockControllerStyle;

@class CPLockController;
@protocol CPLockControllerDelegate

@required
- (void)lockController:(CPLockController *)controller DidFinish:(NSString*)passcode;
- (void)lockControllerDidCancel;

@end


@interface CPLockController : UIViewController <UITextFieldDelegate> {
	//Public vars
	CPLockControllerStyle style;
	NSString *passcode;
	NSString *prompt;
	NSString *title;
	NSString *name;
	id <CPLockControllerDelegate> delegate;
	BOOL hideCode;
	
	//Private vars
	BOOL retry;	
	NSMutableString *tempString;	
	//UI Elements
	UITextField *hiddenField;
	UINavigationItem *navigationItem;
	UILabel *promptLabel;
	UILabel *subPromptLabel;
	UITextField *field1;
	UITextField *field2;
	UITextField *field3;
	UITextField *field4;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) CPLockControllerStyle style;
@property (nonatomic, retain) NSString *passcode;
@property (nonatomic, retain) NSString *prompt;
@property (nonatomic) BOOL hideCode;
@property (nonatomic, retain) NSString *name;

- (void)setTitle:(NSString *)title;

@end
