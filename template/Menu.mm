//
//  Menu.m
//  ModMenu
//
//  Created by Joey on 3/14/19.
//  Copyright © 2019 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwitchesTemplate.h"

@implementation Menu {
    CGPoint lastMenuLocation;
    UILabel *menuTitle;
    UIView *header;
    UIView *footer;
}

// For saving to the pref.plist
NSUserDefaults *defaults;

UIScrollView *scrollView;
CGFloat menuWidth;
CGFloat scrollViewX;
NSString *credits;
UIColor *switchOnColor;
NSString *switchTitleFont;
UIColor *switchTitleColor;
UIColor *infoButtonColor;
NSString *menuIconBase64;
NSString *menuButtonBase64;

//main window of the app we'll be injecting to.
UIWindow *mainWindow;
// getting the self view, need this so we can hide the menu when showing descriptions of hacks.
UIView *selfView;

// will increase with every switch!
float scrollViewHeight = 0;

-(id)initWithTitle:(NSString *)title_ titleColor:(UIColor *)titleColor_ titleFont:(NSString *)titleFont_ credits:(NSString *)credits_ headerColor:(UIColor *)headerColor_ switchOffColor:(UIColor *)switchOffColor_ switchOnColor:(UIColor *)switchOnColor_ switchTitleFont:(NSString *)switchTitleFont_ switchTitleColor:(UIColor *)switchTitleColor_ infoButtonColor:(UIColor *)infoButtonColor_ maxVisibleSwitches:(int)maxVisibleSwitches_ menuWidth:(CGFloat )menuWidth_ menuIcon:(NSString *)menuIconBase64_ menuButton:(NSString *)menuButtonBase64_ {
    
    mainWindow = [UIApplication sharedApplication].keyWindow;
    selfView = self;
    
    menuWidth = menuWidth_;
    switchOnColor = switchOnColor_;
    
    credits = credits_;
    switchTitleFont = switchTitleFont_;
    switchTitleColor = switchTitleColor_;
    infoButtonColor = infoButtonColor_;

    menuButtonBase64 = menuButtonBase64_;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    // in this we can add stuff.
    self = [super initWithFrame:CGRectMake(0,0,menuWidth_, maxVisibleSwitches_ * 50 + 50)];
    self.center = mainWindow.center;
    self.layer.opacity = 0.0f;
    
    //this is the header (where the title of menu is at.
    header = [[UIView alloc]initWithFrame:CGRectMake(0, 1, menuWidth_, 50)];
    header.backgroundColor = headerColor_;
    CAShapeLayer *headerLayer = [CAShapeLayer layer];
    headerLayer.path = [UIBezierPath bezierPathWithRoundedRect: header.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    header.layer.mask = headerLayer;
    [self addSubview:header];

    NSData* data = [[NSData alloc] initWithBase64EncodedString:menuIconBase64_ options:0];
    UIImage* menuIconImage = [UIImage imageWithData:data];      
    
    //menu icon -> click it & credits popup thingy
    UIButton *menuIcon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuIcon.frame = CGRectMake(5, 1, 50, 50);
    menuIcon.backgroundColor = [UIColor clearColor];
    [menuIcon setBackgroundImage:menuIconImage forState:UIControlStateNormal];
    
    [menuIcon addTarget:self action:@selector(menuIconTapped) forControlEvents:UIControlEventTouchDown];
    [header addSubview:menuIcon];
    
    //this is the scroll view, here will the hacks be placed in.
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, header.self.bounds.size.height, menuWidth_, self.bounds.size.height - header.self.bounds.size.height)];
    scrollView.backgroundColor = switchOffColor_;
    [self addSubview:scrollView];
    
    // we need this for the switches.
    scrollViewX = scrollView.self.bounds.origin.x;
    
    //title of the menu
    menuTitle = [[UILabel alloc]initWithFrame:CGRectMake(55, -2, menuWidth_ - 60, 50)];
    menuTitle.text = title_;
    menuTitle.textColor = titleColor_;
    menuTitle.font = [UIFont fontWithName:titleFont_ size:30.0f];
    menuTitle.adjustsFontSizeToFitWidth = true;
    menuTitle.textAlignment = NSTextAlignmentCenter;
    [header addSubview: menuTitle];
    
    //footer -> added because menu looks ugly otherwise.
    footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 1, menuWidth_, 20)];
    footer.backgroundColor = headerColor_;
    CAShapeLayer *footerLayer = [CAShapeLayer layer];
    footerLayer.path = [UIBezierPath bezierPathWithRoundedRect: footer.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    footer.layer.mask = footerLayer;
    [self addSubview:footer];
    
    //handle the dragging of the menu
    UIPanGestureRecognizer *dragMenuRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(menuDragged:)];
    [header addGestureRecognizer:dragMenuRecognizer];
    
    // double tap the header = close the menu
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMenu:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [header addGestureRecognizer:tapGestureRecognizer];
    
    [mainWindow addSubview:self];
    [self showMenuButton];
    
    return self;
}

//checking the touches on the menu, which will be used to retireve it's location.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    lastMenuLocation = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    
    [super touchesBegan:touches withEvent:event];
}

//handle the new location of menu when dragged to a specific point.
- (void)menuDragged:(UIPanGestureRecognizer *)pan {
    CGPoint newLocation = [pan translationInView:self.superview];
    
    self.frame = CGRectMake(lastMenuLocation.x + newLocation.x, lastMenuLocation.y + newLocation.y, self.frame.size.width, self.frame.size.height);
}

// double tap the header for hiding the menu!
- (void)hideMenu:(UITapGestureRecognizer *)tap {
    if(tap.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^ {
            self.alpha = 0.0f;
        }];
    }
}

// This method will make the menu appear.
-(void)showMenu:(UITapGestureRecognizer *)tapGestureRecognizer {
    if(tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^ {
            self.alpha = 1.0f;
        }];

        //restore last "session" (where the switches on etc)
        restoreLastSession();
    }
}

/*
     This method will be called when the menu has been opened.
     This will show the correct colors etc & make sure if a switch was on it will inject the correct patch.
*/
void restoreLastSession() {
    for(OffsetPatcher *op in scrollView.subviews) {
        if([op isKindOfClass:[OffsetPatcher class]]) {
            
            // get the offsets for the switch
            std::vector<uint64_t> offsets = [op getOffsets];
            // get the bytes for the switch
            std::vector<uint64_t>bytes = [op getBytes];
            //get the memorypatch for the switch
            std::vector<MemoryPatch> memoryPatches = [op getMemoryPatches];
            
            if([defaults boolForKey:[op getPreferencesKey]]) {
                op.backgroundColor = switchOnColor;
                
                for(int i = 0; i < offsets.size(); i++) {
                    if(memoryPatches[i].Modify()) {
                       NSLog(@"[Mod Menu] - Patched succesfully!");
                    } else {
                        NSLog(@"[Mod Menu] - Patched unsuccesfully...");
                    }
                }
            } 
            else {
                op.backgroundColor = [UIColor clearColor];
                
                for(int i = 0; i < offsets.size(); i++) {
                    if(memoryPatches[i].Restore()) {
                        NSLog(@"[Mod Menu] - Restored succesfully!");
                    } else {
                        NSLog(@"[Mod Menu] - Restored unsuccesfully...");
                    }
                }
            }
        }
    }
 
    for(TextFieldSwitch *tfs in scrollView.subviews) {
        if([tfs isKindOfClass:[TextFieldSwitch class]]) {
            if([defaults boolForKey:[tfs getPreferencesKey]]) {
                tfs.backgroundColor = switchOnColor;
            } else {
                tfs.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

-(void)showMenuButton {
    NSData* data = [[NSData alloc] initWithBase64EncodedString:menuButtonBase64 options:0];
    UIImage* menuButtonImage = [UIImage imageWithData:data];        
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuButton.frame = CGRectMake((mainWindow.frame.size.width/2), (mainWindow.frame.size.height/2), 50, 50);
    menuButton.backgroundColor = [UIColor clearColor];
    [menuButton setBackgroundImage:menuButtonImage forState:UIControlStateNormal];
    
    //Adding a tap gesture to the button
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMenu:)];
    [menuButton addGestureRecognizer:tapGestureRecognizer];
    
    //Adding a dragging control event to the button
    [menuButton addTarget:self action:@selector(buttonDragged:withEvent:)
       forControlEvents:UIControlEventTouchDragInside];
    [mainWindow addSubview:menuButton];
}

// handler for when the user is draggin the menu.
- (void)buttonDragged:(UIButton *)button withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);
}

// When the menu icon(on the header) has been tapped, we want to show proper credits!
-(void)menuIconTapped {
    [self showPopup:menuTitle.text description:credits];
    selfView.layer.opacity = 0.0f;
}

-(void)showPopup:(NSString *)title_ description:(NSString *)description_ {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.shouldDismissOnTapOutside = NO;
    alert.customViewColor = [UIColor purpleColor];
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;    

    [alert addButton: @"Ok!" actionBlock: ^(void) {
        selfView.layer.opacity = 1.0f;
    }];       

    [alert showInfo:title_ subTitle:description_ closeButtonTitle:nil duration:9999999.0f];
}

// this method will add a switch to the menu, this is being used in switchestemplate.mm
- (void)addOffsetSwitchToMenu:(OffsetPatcher *)offsetPatcher {
    
    // For when it has been clicked, we need to do something.
    [offsetPatcher addTarget:self action:@selector(hackClicked:) forControlEvents:UIControlEventTouchDown];
    
    //increase the scrollview height by it's switch height (which is 50) & add it to the scroll view.
    scrollViewHeight += 50;
    scrollView.contentSize = CGSizeMake(menuWidth, scrollViewHeight);
    [scrollView addSubview:offsetPatcher];
}

// What to do when a offset switch is being clicked?
-(void)hackClicked:(OffsetPatcher *)offsetPatcher {
    
    // get offsets, bytes & the according memory patch.
    std::vector<uint64_t> offsets = [offsetPatcher getOffsets];
    std::vector<uint64_t>bytes = [offsetPatcher getBytes];
    std::vector<MemoryPatch> memoryPatches = [offsetPatcher getMemoryPatches];
    
    bool isOn = [defaults boolForKey:[offsetPatcher getPreferencesKey]];
    
    //If it's clicked while it was NOT on, change it to what it should be when its on.
    if(!isOn) {
        
        for(int i = 0; i < offsets.size(); i++) {
               //apply hack!
            if(memoryPatches[i].Modify()) {
                NSLog(@"[Mod Menu] - Patched succesfully!");
            } else {
                NSLog(@"[Mod Menu] - Patched unsuccesfully...");
            }
        }
     
        [UIView animateWithDuration:0.3 animations:^ {
            offsetPatcher.backgroundColor = switchOnColor;
        }];
        
        [defaults setBool:true forKey:[offsetPatcher getPreferencesKey]];
    } else {
    
        for(int i = 0; i < offsets.size(); i++) {
            //Restore hack!
            if(memoryPatches[i].Restore()) {
                NSLog(@"[Mod Menu] - Restored succesfully!");
            } else {
                NSLog(@"[Mod Menu] - Restored unsuccesfully...");
            }
        }
 
        [UIView animateWithDuration:0.3 animations:^ {
            offsetPatcher.backgroundColor = [UIColor clearColor];
        }];
        
        [defaults setBool:false forKey:[offsetPatcher getPreferencesKey]];
 
    }
}


// this method will add a textfield switch to the menu, this is being used in switchestemplate.mm
- (void)addTextfieldSwitchToMenu:(TextFieldSwitch *)textfieldSwitch {
    
    // For when it has been clicked, we need to do something.
    [textfieldSwitch addTarget:self action:@selector(textfieldClicked:) forControlEvents:UIControlEventTouchDown];
    
    //increase the scrollview height by it's switch height (which is 50) & add it to the scrollview.
    scrollViewHeight += 50;
    scrollView.contentSize = CGSizeMake(menuWidth, scrollViewHeight);
    [scrollView addSubview:textfieldSwitch];
}

// What to do when a textfield has been clicked?
-(void)textfieldClicked:(TextFieldSwitch *)textfieldSwitch {
    
    bool isOn = [defaults boolForKey:[textfieldSwitch getPreferencesKey]];
    
    //If it's clicked while it was NOT on, change it to what it should be when its on.
    if(!isOn) {
        [UIView animateWithDuration:0.3 animations:^ {
            textfieldSwitch.backgroundColor = switchOnColor;
        }];

        [defaults setBool:true forKey:[textfieldSwitch getPreferencesKey]];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^ {
            textfieldSwitch.backgroundColor = [UIColor clearColor];
        }];
        
        [defaults setBool:false forKey:[textfieldSwitch getPreferencesKey]];
    }
    
}

// this method will add a sliderswitch to the menu, this is being used in switchestemplate.mm
- (void)addSliderSwitchToMenu:(SliderSwitch *)sliderSwitch {
    
    // For when it has been clicked, we need to do something.
    [sliderSwitch addTarget:self action:@selector(sliderSwitchClicked:) forControlEvents:UIControlEventTouchDown];
    
    //increase the scrollview height by it's switch height (which is 50) & add it to the scrollview.
    scrollViewHeight += 50;
    scrollView.contentSize = CGSizeMake(menuWidth, scrollViewHeight);
    [scrollView addSubview:sliderSwitch];
}

// What to do if a slider switch has been clicked?
-(void)sliderSwitchClicked:(SliderSwitch *)sliderSwitch {
    
    bool isOn = [defaults boolForKey:[sliderSwitch getPreferencesKey]];
    
    //If it's clicked while it was NOT on, change it to what it should be when its on.
    if(!isOn) {
        [UIView animateWithDuration:0.3 animations:^ {
            sliderSwitch.backgroundColor = switchOnColor;
        }];
        
        [defaults setBool:true forKey:[sliderSwitch getPreferencesKey]];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^ {
            sliderSwitch.backgroundColor = [UIColor clearColor];
        }];
        
        [defaults setBool:false forKey:[sliderSwitch getPreferencesKey]];
    }
    
}
@end // End of menu class!




/*
        OFFSET PATCHER STARTS HERE!
*/

@implementation OffsetPatcher {
    NSString *preferencesKey;
    std::vector<uint64_t> offsets;
    std::vector<uint64_t> bytes;
    std::vector<MemoryPatch> memoryPatches;
    UILabel *offsetPatchSwitch;
    NSString *description;
}

- (id)initHackNamed:(NSString *)hackName_ description:(NSString *)description_ offsets:(std::vector<uint64_t>)offsets_ bytes:(std::vector<uint64_t>)bytes_ {
    
    offsets = offsets_;
    bytes = bytes_;
    description = description_;

    // add memory patch to memorypatches vector array
    for(int i = 0; i < offsets.size(); i++) {

        if(bytes[i] < 0xFFFFFFFF) {
            bytes[i] = _OSSwapInt32(bytes[i]);
            memoryPatches.push_back(MemoryPatch(NULL,offsets[i], &bytes[i], sizeof(uint32_t)));
        } else {
            bytes[i] = _OSSwapInt64(bytes[i]);
            memoryPatches.push_back(MemoryPatch(NULL,offsets[i], &bytes[i], sizeof(uint64_t)));
        }
    }
    
    preferencesKey = hackName_;
    
    self = [super initWithFrame:CGRectMake(-1, scrollViewX + scrollViewHeight - 1, menuWidth + 2, 50)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    offsetPatchSwitch = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, menuWidth - 60, 50)];
    offsetPatchSwitch.text = hackName_;
    offsetPatchSwitch.textColor = switchTitleColor;
    offsetPatchSwitch.font = [UIFont fontWithName:switchTitleFont size:18];
    offsetPatchSwitch.adjustsFontSizeToFitWidth = true;
    offsetPatchSwitch.textAlignment = NSTextAlignmentCenter;
    [self addSubview:offsetPatchSwitch];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(menuWidth - 30, 15, 20, 20);
    infoButton.tintColor = infoButtonColor;
    
    UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInfo:)];
    [infoButton addGestureRecognizer:infoTap];
    [self addSubview:infoButton];
    
    return self;
}


// show info (description)
-(void)showInfo:(UIGestureRecognizer *)gestureRec {
    Menu *menu = [[Menu alloc] init];
    
    if(gestureRec.state == UIGestureRecognizerStateEnded) {
        [menu showPopup:[self getPreferencesKey] description:[self getDescription]];
        selfView.layer.opacity = 0.0f;
    }
}

-(NSString *)getPreferencesKey {
    return preferencesKey;
}

-(NSString *)getDescription {
    return description;
}

- (std::vector<uint64_t>)getOffsets {
    return offsets;
}

- (std::vector<uint64_t>)getBytes {
    return bytes;
}

- (std::vector<MemoryPatch>)getMemoryPatches {
    return memoryPatches;
}

@end //end of OffsetPatcher class




/*
        TEXTFIELD SWITCH STARTS HERE!
*/

@implementation TextFieldSwitch {
    NSString *preferencesKey;
    NSString *switchValueKey;
    NSString *description;
    UILabel *textfieldSwitch;
    UILabel *descirptionLabel;
    UITextField *textfieldValue;
}

- (id)initTextfieldNamed:(NSString *)hackName_ description:(NSString *)description_ inputBorderColor:(UIColor *)inputBorderColor_ {
    
    //give each switch unique prefkey
    preferencesKey = hackName_;
    //we will store users value here
    switchValueKey = [hackName_ stringByApplyingTransform:NSStringTransformLatinToCyrillic reverse:false];
    
    description = description_;
    
    self = [super initWithFrame:CGRectMake(-1, scrollViewX + scrollViewHeight -1, menuWidth + 2, 50)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //switch styling
    textfieldSwitch = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, menuWidth - 60, 30)];
    textfieldSwitch.text = hackName_;
    textfieldSwitch.textColor = switchTitleColor;
    textfieldSwitch.font = [UIFont fontWithName:switchTitleFont size:18];
    textfieldSwitch.adjustsFontSizeToFitWidth = true;
    textfieldSwitch.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textfieldSwitch];
    
    // input styling
    textfieldValue = [[UITextField alloc]initWithFrame:CGRectMake(menuWidth / 4 - 10, textfieldSwitch.self.bounds.origin.x - 5 + textfieldSwitch.self.bounds.size.height, menuWidth / 2, 20)];
    textfieldValue.layer.borderWidth = 2.0f;
    textfieldValue.layer.borderColor = inputBorderColor_.CGColor;
    textfieldValue.layer.cornerRadius = 10.0f;
    textfieldValue.textColor = switchTitleColor;
    textfieldValue.textAlignment = NSTextAlignmentCenter;
    textfieldValue.delegate = self;
    textfieldValue.backgroundColor = [UIColor clearColor];
    
    // //get value from the plist & show it (if it's not empty).
    if([[NSUserDefaults standardUserDefaults] objectForKey:switchValueKey] != nil) {
        //show saved value inside the textfield!
        textfieldValue.text = [[NSUserDefaults standardUserDefaults] objectForKey:switchValueKey];
    }
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(menuWidth - 30, 15, 20, 20);
    infoButton.tintColor = infoButtonColor;
    
    UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInfo:)];
    [infoButton addGestureRecognizer:infoTap];
    [self addSubview:infoButton];
    
    [self addSubview:textfieldValue];
    
    return self;
}

-(void)showInfo:(UIGestureRecognizer *)gestureRec {
    Menu *menu = [[Menu alloc] init];
    
    if(gestureRec.state == UIGestureRecognizerStateEnded) {
        [menu showPopup:[self getPreferencesKey] description:[self getDescription]];
        selfView.layer.opacity = 0.0f;
    }
}

// so when click "return" the keyboard goes way, got it from internet. Common thing apparantly
-(BOOL)textFieldShouldReturn:(UITextField*)textfieldValue_ {
    
    // value of textfield will be pref key but then encoded.
    switchValueKey = [[self getPreferencesKey] stringByApplyingTransform:NSStringTransformLatinToCyrillic reverse:false];
    [defaults setObject:textfieldValue_.text forKey:[self getSwitchValueKey]];
    [textfieldValue_ resignFirstResponder];
    
    return true;
}

-(NSString *)getPreferencesKey {
    return preferencesKey;
}

-(NSString *)getSwitchValueKey {
    return switchValueKey;
}

-(NSString *)getDescription {
    return description;
}
@end // end of TextFieldSwitch Class






/*
    SLIDER SWITCH STARTS HERE!
 */

@implementation SliderSwitch {
    NSString *hackName;
    NSString *preferencesKey;
    NSString *switchValueKey;
    NSString *description;
    UILabel *sliderSwitch;
    UILabel *descirptionLabel;
    UISlider *sliderValue;
    float valueOfSlider;
}

- (id)initSliderNamed:(NSString *)hackName_ description:(NSString *)description_ minimumValue:(float)minimumValue_ maximumValue:(float)maximumValue_ sliderColor:(UIColor *)sliderColor_{
    
    //give each switch unique prefkey
    preferencesKey = hackName_;
    //we will store users value here
    switchValueKey = [hackName_ stringByApplyingTransform:NSStringTransformLatinToCyrillic reverse:false];
    
    description = description_;
    
    self = [super initWithFrame:CGRectMake(-1, scrollViewX + scrollViewHeight -1, menuWidth + 2, 50)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //switch styling
    sliderSwitch = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, menuWidth - 60, 30)];
    sliderSwitch.text = [NSString stringWithFormat:@"%@ %.2f", hackName_, sliderValue.value];
    sliderSwitch.textColor = switchTitleColor;
    sliderSwitch.font = [UIFont fontWithName:switchTitleFont size:18];
    sliderSwitch.adjustsFontSizeToFitWidth = true;
    sliderSwitch.textAlignment = NSTextAlignmentCenter;
    [self addSubview:sliderSwitch];
    
    // input styling
    sliderValue = [[UISlider alloc]initWithFrame:CGRectMake(menuWidth / 4 - 20, sliderSwitch.self.bounds.origin.x - 4 + sliderSwitch.self.bounds.size.height, menuWidth / 2 + 20, 20)];
    sliderValue.thumbTintColor = sliderColor_;
    sliderValue.minimumTrackTintColor = switchTitleColor;
    sliderValue.maximumTrackTintColor = switchTitleColor;
    sliderValue.minimumValue = minimumValue_;
    sliderValue.maximumValue = maximumValue_;
    sliderValue.continuous = true;
    [sliderValue addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    valueOfSlider = sliderValue.value;
    
    // //get value from the plist & show it (if it's not empty).
    if([[NSUserDefaults standardUserDefaults] objectForKey:switchValueKey] != nil) {
        sliderValue.value = [[NSUserDefaults standardUserDefaults] floatForKey:switchValueKey];
        sliderSwitch.text = [NSString stringWithFormat:@"%@ %.2f", hackName_, sliderValue.value];
    }
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(menuWidth - 30, 15, 20, 20);
    infoButton.tintColor = infoButtonColor;
    
    UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInfo:)];
    [infoButton addGestureRecognizer:infoTap];
    [self addSubview:infoButton];
    
    [self addSubview:sliderValue];
    
    return self;
}

-(void)showInfo:(UIGestureRecognizer *)gestureRec {
    Menu *menu = [[Menu alloc] init];
    
    if(gestureRec.state == UIGestureRecognizerStateEnded) {
        [menu showPopup:[self getPreferencesKey] description:[self getDescription]];
        selfView.layer.opacity = 0.0f;
    }
}

-(void)sliderValueChanged:(UISlider *)slider_ {
    
    // value of slider will be prefkey but then "Encoded"
    switchValueKey = [[self getPreferencesKey] stringByApplyingTransform:NSStringTransformLatinToCyrillic reverse:false];

    sliderSwitch.text = [NSString stringWithFormat:@"%@ %.2f", [self getPreferencesKey], slider_.value];
    
    [defaults setFloat:slider_.value forKey:[self getSwitchValueKey]];
}

-(NSString *)getPreferencesKey {
    return preferencesKey;
}

-(NSString *)getSwitchValueKey {
    return switchValueKey;
}

-(NSString *)getDescription {
    return description;
}

@end // end of SliderSwitch class
