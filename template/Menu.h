//
//  Menu.h
//  ModMenu
//
//  Created by Joey on 3/14/19.
//  Copyright © 2019 Joey. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "KittyMemory/MemoryPatch.hpp"
#import "SCLAlertView/SCLAlertView.h"

#import <vector>
#import <initializer_list>

@class OffsetSwitch;
@class TextFieldSwitch;
@class SliderSwitch;
@class Switches;

@interface Menu : UIView

-(id)initWithTitle:(const char *)title_ titleColor:(UIColor *)titleColor_ titleFont:(const char *)titleFont_ credits:(const char *)credits_ headerColor:(UIColor *)headerColor_ switchOffColor:(UIColor *)switchOffColor_ switchOnColor:(UIColor *)switchOnColor_ switchTitleFont:(const char *)switchTitleFont_ switchTitleColor:(UIColor *)switchTitleColor_ infoButtonColor:(UIColor *)infoButtonColor_ maxVisibleSwitches:(int)maxVisibleSwitches_ menuWidth:(CGFloat )menuWidth_ menuIcon:(NSString *)menuIconBase64_ menuButton:(NSString *)menuButtonBase64_;
-(void)setFrameworkName:(const char *)name_;
-(const char *)getFrameworkName;


-(void)showMenuButton;
-(void)addSwitchToMenu:(id)switch_;
-(void)showPopup:(NSString *)title_ description:(NSString *)description_;

@end

@interface OffsetSwitch : UIButton {
	NSString *preferencesKey;
	NSString *description;
    UILabel *switchLabel;
}

- (id)initHackNamed:(NSString *)hackName_ description:(NSString *)description_ offsets:(std::vector<uint64_t>)offsets_ bytes:(std::vector<std::string>)bytes_;
-(void)showInfo:(UIGestureRecognizer *)gestureRec;

-(NSString *)getPreferencesKey;
-(NSString *)getDescription;
- (std::vector<MemoryPatch>)getMemoryPatches;


@end

@interface TextFieldSwitch : OffsetSwitch<UITextFieldDelegate> {
	NSString *switchValueKey;
}

- (id)initTextfieldNamed:(NSString *)hackName_ description:(NSString *)description_ inputBorderColor:(UIColor *)inputBorderColor_;

-(NSString *)getSwitchValueKey;

@end

@interface SliderSwitch : TextFieldSwitch

- (id)initSliderNamed:(NSString *)hackName_ description:(NSString *)description_ minimumValue:(float)minimumValue_ maximumValue:(float)maximumValue_ sliderColor:(UIColor *)sliderColor_;

@end


@interface Switches : UIButton

-(void)addSwitch:(const char *)hackName_ description:(const char *)description_;

- (void)addOffsetSwitch:(const char *)hackName_ description:(const char *)description_ offsets:(std::initializer_list< const char * >)offsets_ bytes:(std::initializer_list< const char * >)bytes_;

- (void)addTextfieldSwitch:(const char *)hackName_ description:(const char *)description_ inputBorderColor:(UIColor *)inputBorderColor_;

- (void)addSliderSwitch:(const char *)hackName_ description:(const char *)description_ minimumValue:(float)minimumValue_ maximumValue:(float)maximumValue_ sliderColor:(UIColor *)sliderColor_;

- (NSString *)getValueFromSwitch:(const char *)name;
-(bool)isSwitchOn:(const char *)switchName;

@end
