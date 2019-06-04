# iOS Mod Menu Template for Theos!

<div style="text-align: center;">
<b>Sample UI of the Menu:</b><br>

<img src="https://i.imgur.com/f20XTb4.png">
</div>

<br>

### Features:
* Customizable UI
* Customizable menu & button image icon
* 4 types of switches:
	* Offset Patcher Switch
	* Empty Switch
	* Textfield Switch
	* Slider Switch

* Backend Offset Patcher Switch is based on [KittyMemory](https://github.com/MJx0/KittyMemory)
	* Original bytes are <b>not</b> required
	* Write bytes, instead of integers
	* Supports MSHookMemory
	* Open Source --> want something changed? Do it!

<br>

### Usage:

Download the .tar file & place it inside '/var/theos/templates/ios' & then run nic.pl to create a project <br>
If you want to customize the template, download the github project & copy the "project" folder on your phone. <br>
Make the changes you want, cd into your project & run this command: '/var/theos/bin/nicify.pl ./'. <br>
This will create a new .tar file inside the folder, place this in '/var/theos/templates/ios'. <br>


<b> Offset Patcher Switch: </b>
```obj-c
  [switches addOffsetSwitch:@"One Hit Kill"
              description:@"You can't die!"
                offsets:{0x1001BB2C0, 0x1002CB3B0}
                  // Get Bytes Here: http://shell-storm.org/online/Online-Assembler-and-Disassembler/
                  bytes:{"\x00\xe0\xbf\x12\xc0\x03\x5f\xd6", "\xc0\x03\x5f\xd6"}];
```

<b> Empty Switch: </b>
```obj-c
  [switches addSwitch:@"Anti Ban"
              description:@"You can't get banned, keep this enabled!"];
```
<b> Textfield Switch: </b>
```obj-c
  [switches addTextfieldSwitch:@"Custom Gold: "
              description:@"Here you can enter your own gold amount!"
                inputBorderColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]];
```
<b> Slider Switch: </b>
```obj-c
  [switches addSliderSwitch:@"Custom Move Speed: "
              description:@"Set your custom move speed!"
                minimumValue:0
                  maximumValue:10
                    sliderColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]];  
```
<b> Checking if a switch is on:
```obj-c
bool isOn = [switches isSwitchOn:@"Switch Name Goes Here"];
    
if(isOn) {
	//Do stuff
}
    
//Or check directly:
if([switches isSwitchOn:@"Switch Name Goes Here"]) {
    // Do stuff
}
```
<b> Getting textfield or slider value: </b>
```obj-c
int userValue = [[switches getValueFromSwitch:@"Switch Name Goes Here"] intValue];
float userValue2 = [[switches getValueFromSwitch:@"Switch Name Goes Here"] floatValue];
```

<br>
The sample.xm in the project shows an example project.
<br>
<br>

### To Do:
* Re-design the textfield UI, I'm not a fan of it.
* Numeric Keyboard only with textfield
* You tell me!

<br>

### Contact:
If you have any questions, suggestions, bugs or anything else:
<br> <b>Discord:</b> Joey #0309
<br><b>iOSGods Account:</b> [https://iosgods.com/profile/122392-ted2/](https://iosgods.com/profile/122392-ted2/)
<br><b>Twitter:</b> [https://twitter.com/Joey_Not_Joey](https://twitter.com/Joey_Not_Joey)

