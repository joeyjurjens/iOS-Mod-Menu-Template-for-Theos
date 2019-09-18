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
	* Supports MSHookMemory

* Open Source Menu

<br>

### Usage:

Download the .tar file & place it inside '/var/theos/templates/ios' & then run nic.pl to create a project <br>
If you want to customize the template, download the github project & copy the "project" folder on your phone. <br>
Make the changes you want, cd into your project & run this command: '/var/theos/bin/nicify.pl ./'. <br>
This will create a new .tar file inside the folder, place this in '/var/theos/templates/ios'. <br>

<b> Patching a offset without switch: </b>
```c
  patchOffset(0x1002DB3C8, 0xC0035FD6);
  patchOffset(0x10020D2D3, 0x00008052C0035FD6);
```


<b> Offset Patcher Switch: </b> <br>
<b> Note </b>: "Bytes" allow up to <b> two </b> arm instructions per offset, not more. <br>

```obj-c
  [switches addOffsetSwitch:@"One Hit Kill"
              description:@"Enemy will die instantly!"
                offsets:{0x1001BB2C0, 0x1002CB3B0}
                  bytes:{0x00E0BF12C0035FD6, 0xC0035FD6}];
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
* Offset Tester Switch
* You tell me!

<br>

### Contact:
If you have any questions, suggestions, bugs or anything else:
<br> <b>Discord:</b> Joey #0309

