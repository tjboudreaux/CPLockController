//
//  SampleAppViewController.h
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright  2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLockController.h"

@interface SampleAppViewController : UIViewController <CPLockControllerDelegate> {

}

- (IBAction)requirePasscode:(id)sender;
- (IBAction)changePasscode:(id)sender;

@end

