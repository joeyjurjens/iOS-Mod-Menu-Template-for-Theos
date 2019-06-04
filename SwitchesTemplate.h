//
//  SwitchesTemplate.h
//  ModMenu
//
//  Created by Joey on 3/28/19.
//  Copyright © 2019 Joey. All rights reserved.
//

#import "Menu.h"

@interface Switches : UIButton

-(void)addSwitch:(NSString *)hackName_ description:(NSString *)description_;

- (void)addOffsetSwitch:(NSString *)hackName_ description:(NSString *)description_ offsets:(std::initializer_list<uint64_t>)offsets_ bytes:(std::initializer_list<const void *>)bytes_;

- (void)addTextfieldSwitch:(NSString *)hackName_ description:(NSString *)description_ inputBorderColor:(UIColor *)inputBorderColor_;

- (void)addSliderSwitch:(NSString *)hackName_ description:(NSString *)description_ minimumValue:(float)minimumValue_ maximumValue:(float)maximumValue_ sliderColor:(UIColor *)sliderColor_;

- (NSString *)getValueFromSwitch:(NSString *)name;
-(bool)isSwitchOn:(NSString *)switchName;

@end
