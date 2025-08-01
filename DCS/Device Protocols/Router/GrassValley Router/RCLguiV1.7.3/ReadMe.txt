Known issues with the Ethernet implementation include:

1) Timeout mechanism is working. This means if a command that is sent through the Test GUI 
   is not supported by the RCL Server, it will timeout in 5 seconds.
2) Commands that are supported by the RCL Server should work whether or not unsupported 
   commands are sent to the Server.  (Earlier, this was failing but this problem has been 
   fixed both in the RCL Client as well as the Test Program).
3) The "Run Infinitely" option has been disabled but the Script File mechanism works with 
   ‘multiple iterations’.  I have tested here with 6-8 iterations of an exhaustive script file.
4) Level Bitmap entries must be entered manually as an integer value greater than 0.
   (e.g. if levels 1,3 and 4 are set in binary notation, then the decimal value of 13 
   must be entered).

Please use the Ethernet Script File (EthScript.txt) for script mode testing.

----------------------------------------------------------------------------

The steps to use RCL GUI program for Serial connection are as follows:

As of now, the RCL GUI program for serial connection supports only the Test Script mode 
(Does not work in the User Interface mode)

1) In the connections tab :
	a) Select Serial in Network Protocol combo box
	b) Select Native Protocol in Application Protocol combo box
	c) Select COM1 or COM2 in Serial Port depending on which port is used on the 
           test PC.
	d) Click on Connect button...."Connection established..." will be displayed in 
           the Connection Status window.
	e) Select Test Script radio button
2) In the Run Script tab :
	a) Give the full path to the test script file in the filename edit 
           box(forward or backward slash can be used) or the browse option can be used 
           to navigate to the location of test script file 
	b) Logging can be enabled(preferable) with the desired debug level(range 0 - 4). 
           Specify the complete path to the log file in the Log file edit box
	c) Click on Run Test Script button. 
 	   
	Note : It takes few minutes for the responses to be displayed depending on the
 	number of commands in the script file.

Please use the Serial Script File (SerScript.txt) for Script mode testing.

NOTE:
Please refer to the Script File User Guide as well as the RCL Test Program User Guide
before attempting to use this program for testing. You will need to change sources, 
destinations, levels (wherever required) in the Script File according to the Configuration 
you are using. The Script File User Guide mentions the list of commands supported by 
the RCL Server. The RCL Test program User guide mentions a list of commands that can be 
tested through each Tab, and also the purpose of each control in the GUI. One more point, 
when using the RCL Server for testing, select Native Protocol as the Application Protocol 
and not Router Control Language. 