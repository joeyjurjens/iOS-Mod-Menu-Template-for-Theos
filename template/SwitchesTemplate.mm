//
//  SwitchesTemplate.m
//  ModMenu
//
//  Created by Joey on 3/28/19.
//  Copyright © 2019 Joey. All rights reserved.
//

#import "SwitchesTemplate.h"


@implementation Switches

// init the menu
static Menu *menu = [[Menu alloc]init];

-(void)addSwitch:(NSString *)hackName_ description:(NSString *)description_ {
    
    // We can just use the offsetpatcher method, but just not enter any offsets :)
    OffsetPatcher *offsetPatch = [[OffsetPatcher alloc]initHackNamed:hackName_ description:description_ offsets:std::vector<uint64_t>{} bytes:std::vector<const void *>{}];
    
    //adding it to the menu
    [menu addOffsetSwitchToMenu:offsetPatch];
    
}

/*
 This is the "template" for simple offset patching.
 */

- (void)addOffsetSwitch:(NSString *)hackName_ description:(NSString *)description_ offsets:(std::initializer_list<uint64_t>)offsets_ bytes:(std::initializer_list<const void *>)bytes_ {
    
    std::vector<uint64_t> offsetVector;
    std::vector<const void *> bytesVector;
    
    offsetVector.insert(offsetVector.begin(), offsets_.begin(), offsets_.end());
    bytesVector.insert(bytesVector.begin(), bytes_.begin(), bytes_.end());
    
    OffsetPatcher *offsetPatch = [[OffsetPatcher alloc]initHackNamed:hackName_ description:description_ offsets:offsetVector bytes:bytesVector];
    
    //adding it to the menu
    [menu addOffsetSwitchToMenu:offsetPatch];
}



/*
 This is the "template" for user input switch.
 */

- (void)addTextfieldSwitch:(NSString *)hackName_ description:(NSString *)description_ inputBorderColor:(UIColor *)inputBorderColor_ { 
    
    TextFieldSwitch *textfieldSwitch = [[TextFieldSwitch alloc]initTextfieldNamed:hackName_ description:description_ inputBorderColor:inputBorderColor_];
    
    [menu addTextfieldSwitchToMenu:textfieldSwitch];
}

- (void)addSliderSwitch:(NSString *)hackName_ description:(NSString *)description_ minimumValue:(float)minimumValue_ maximumValue:(float)maximumValue_ sliderColor:(UIColor *)sliderColor_ {
    
    SliderSwitch *sliderSwitch = [[SliderSwitch alloc] initSliderNamed:hackName_ description:description_ minimumValue:minimumValue_ maximumValue:maximumValue_ sliderColor:sliderColor_];
    
    [menu addSliderSwitchToMenu:sliderSwitch];
}




// get value from textfield or slider
- (NSString *)getValueFromSwitch:(NSString *)name {
    
    //getting the correct key for the saved input.
    NSString *correctKey =  [name stringByApplyingTransform:NSStringTransformLatinToCyrillic reverse:false];

    if([[NSUserDefaults standardUserDefaults] objectForKey:correctKey]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:correctKey];
    }
    else if([[NSUserDefaults standardUserDefaults] floatForKey:correctKey]) {
        NSString *sliderValue = [NSString stringWithFormat:@"%f", [[NSUserDefaults standardUserDefaults] floatForKey:correctKey]];
        return sliderValue;
    }

    return 0;
}

// this method can be used to check whether a switch is on or not!
-(bool)isSwitchOn:(NSString *)switchName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:switchName];
}

@end
