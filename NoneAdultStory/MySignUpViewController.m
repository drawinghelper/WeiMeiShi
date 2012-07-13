//
//  MySignUpViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "MySignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MySignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MySignUpViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerTitle.png"]]];
    [self.signUpView.usernameField setPlaceholder:@"请填写用户名"];
    self.signUpView.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.signUpView.passwordField setPlaceholder:@"请填写密码"];
    [self.signUpView.emailField setPlaceholder:@"请填写邮箱"];
    self.signUpView.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    // Change button apperance
//    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
//    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
//    
//    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
//    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpDown.png"] forState:UIControlStateHighlighted];
//    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
//    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add background for fields
    //[self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUpFieldBG.png"]]];
    //[self.signUpView insertSubview:fieldsBackground atIndex:1];
    
    [self.signUpView.signUpButton setTitle:@"注册" forState:UIControlStateNormal];

    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set text color
//    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
//    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
//    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
}

- (void)viewDidLayoutSubviews {
    // Set frame for elements
    [self.signUpView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    //[self.fieldsBackground setFrame:CGRectMake(35.0f, 134.0f+30.0f, 250.0f, 174.0f)];
    
    // Move all fields down
    float yOffset = 0.0f;
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x+5.0f, 
                                                       fieldFrame.origin.y+yOffset, 
                                                       fieldFrame.size.width-10.0f, 
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x+5.0f, 
                                                       fieldFrame.origin.y+yOffset, 
                                                       fieldFrame.size.width-10.0f, 
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x+5.0f, 
                                                    fieldFrame.origin.y+yOffset, 
                                                    fieldFrame.size.width-10.0f, 
                                                    fieldFrame.size.height)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
