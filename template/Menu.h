//
//  Menu.h
//  ModMenu
//
//  Created by Joey on 3/14/19.
//  Copyright © 2019 Joey. All rights reserved.
//

#import <vector>
#import "UIKit/UIKit.h"
#import "KittyMemory/MemoryPatch.hpp"
#import "KittyMemory/initializer_list"
#import "SCLAlertView/SCLAlertView.h" 

@class OffsetPatcher;
@class TextFieldSwitch;
@class SliderSwitch;

@interface Menu : UIView

-(id)initWithTitle:(NSString *)title_ titleColor:(UIColor *)titleColor_ titleFont:(NSString *)titleFont_ credits:(NSString *)credits_ headerColor:(UIColor *)headerColor_ switchOffColor:(UIColor *)switchOffColor_ switchOnColor:(UIColor *)switchOnColor_ switchTitleFont:(NSString *)switchTitleFont_ switchTitleColor:(UIColor *)switchTitleColor_ infoButtonColor:(UIColor *)infoButtonColor_ maxVisibleSwitches:(int)maxVisibleSwitches_ menuWidth:(CGFloat )menuWidth_ menuIcon:(NSString *)menuIconBase64_ menuButton:(NSString *)menuButtonBase64_;


-(void)showMenuButton;

-(void)addOffsetSwitchToMenu:(OffsetPatcher *)offsetPatcher;
- (void)addTextfieldSwitchToMenu:(TextFieldSwitch *)textfieldSwitch;
- (void)addSliderSwitchToMenu:(SliderSwitch *)sliderSwitch;

@end

@interface OffsetPatcher : UIButton

- (id)initHackNamed:(NSString *)hackName_ description:(NSString *)description_ offsets:(std::vector<uint64_t>)offsets_ bytes:(std::vector<uint64_t>)bytes_;


-(NSString *)getPreferencesKey;
-(NSString *)getDescription;
-(std::vector<uint64_t>)getOffsets;
- (std::vector<uint64_t>)getBytes;
- (std::vector<MemoryPatch>)getMemoryPatches;


@end

@interface TextFieldSwitch : UIButton<UITextFieldDelegate>

- (id)initTextfieldNamed:(NSString *)hackName_ description:(NSString *)description_ inputBorderColor:(UIColor *)inputBorderColor_;

-(NSString *)getPreferencesKey;
-(NSString *)getSwitchValueKey;
-(NSString *)getDescription;

@end

@interface SliderSwitch : UIButton

- (id)initSliderNamed:(NSString *)hackName_ description:(NSString *)description_ minimumValue:(float)minimumValue_ maximumValue:(float)maximumValue_ sliderColor:(UIColor *)sliderColor_;

-(NSString *)getPreferencesKey;
-(NSString *)getSwitchValueKey;
-(NSString *)getDescription;

@end
