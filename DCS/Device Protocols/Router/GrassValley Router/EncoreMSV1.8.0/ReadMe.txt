Encore V1.8.0, Soft Panels V3.1.0, Visual Status Display V2.0.0, Salvo Editor V2.0.0,
Concerto V1.7.7, Trinix V3.1.0, 7500 V1.7.3, NetConfig 2.0.12, RCL GUI V1.7.3 

Release Information - August, 2010

------------------------------------------------------------------------
The Encore Routing Control System V1.8.0 release contains the following 
bug fixes and known existing system issues for the reader's attention.
------------------------------------------------------------------------
	
			ENCORE
Fixed Defects(44)
	CR89779 - Room names greater than 8 characters can cause failure to retain room configuration during
		upgrade of TLM. Eight characters is the specified name length to use. 

	CR113558 - GSC panels are continuously added and dropped by the panel server when more than approx 40 GSC 				panels are connected.

	CR109196 - Local source takes on second area fail on PMB with 2 areas on destination page and redundant panel 				servers.

	CR70346 - Salvo execution with 64 elements causes switch delay between the first and last take

	CR112366 - Installing default database alone using Encore CD will not install OMN.

	CR108349 - Take notifications occur before the actual take.

	CR93199 - Too much time is required to copy from master to mirror (and vice versa), and do modify and reload 				operations on Panel Server.

	CR106421 - Encore CD does not include instructions or tools (xitami, batch files) to upgrade a 7500 matrix from 				SMS7000 to Encore.

	CR89986 - The segment Share flag is not considered for the RCE export configuration feature.

	CR42957 - Tie Line Manager application prevents RCE logging.

	CR65134 - Encore installation binds to the first network address irrespective of the installation selection.

	CR98949 - The sensitivity of EDP knob scroll needs to be optimized for better usage

	CR61899 - When filing mode is local, cannot take redundant panel server online or offline.

	CR62474 - On PMB, when using “save as” to create a new destination page from one already in the page set list, the 			current destination page in the page set is replaced with the new one created.

	CR90262 - Protects not always dropped when automation device disconnects from Encore RCL Server.

	CR87059 - The support for the QT command to query the tie lines needs to be added.

	CR70960 - Encore LRP does not prevent entry of invalid data when creating salvos.

	CR81454 - Incorrect tally requests sent to Horizon for destinations above 100.

	CR100618 - OUI fails to launch on PC due to hanging kill.exe process.

	CR104554 - SCB crashes when RCE is configured with 32 levels.

	CR112393 - TLM Rooms config and RCE/TLM options lost when saving from flash to new OMN.

	CR112173 - 'QC' command does not return the destination status, if the first level is excluded and the destination 				has breakaway status.

	CR112503 - Using an 8-level configuration using levels 25-32, the PMB does not display the level names in Level Page 		Mode.

	CR112548 - The alarm status is not properly updated for SCB secondary power supply and CPL matrix connect 				status while querying through QE,AC command.

	CR109964 - Query destination status (QK, QD, QJ and QC) commands returns the null response when queried first 			time after connection.

	CR110026 - The RCE export feature does not consider the primary Level information.

	CR113206 - Baud Rate 57600 is not available in OUI to configure for serial clients.

	CR106555 - Panel shows 'NoRouter' when the Preset Area is taken offline and Take operation is performed
		on a destination from another area.

	CR73665 - OUI does not update other salvo page sets when a page name is deleted. PMB panel displays
		'default' page in the location of the page that was deleted.

	CR73854 - A destination page deleted from the system, from within one destination page set, is still shown as part of 		another destination page set.

	CR62028 - OUI configuration of GSC panels after a rename before the panel is online causes panel servers to not 				synchronize.

	CR60456 - Panel group Masters should propagate flashing LED rate to Expansion panels.

	CR62675 - NP Matrix driver should show Parked as the status instead of <undef> for dis-connected destinations.

	CR30676 - The Router Controller application turns the Modify button red whenever there is unsaved data. The 				exception to this is the CPL matrix configuration parameters (controller attributes and I/O attributes).

	CR42445 - Redundant CP servers will not synchronize if there is no router in their network.

	CR42570 - The Router Controller application allows more than one CPL channel to be configured. Such duplicate 				configuration should be avoided. If not, the error message “Cannot initialize channel on port (-1)” appears 		for the CPL channel when resync comms is selected.

	CR43669 - Multiple Level Tieline will not work if the first available Level does not have a path.

	CR73977 - 7500WB gives false PS SNMP errors.

	CR46050 - If redundant Control Panel Servers are not in sync the supervisory panel server does not allow edits on 				control panels.

	CR50830 - For every destination level involved, if there is not a corresponding source level, the Take will fail and 				none of the levels will switch. A Tie Line cannot switch an unspecified level.

	CR35005 - Control panels will reset after an OUI edit change, even if no configuration changes were performed.

	CR84870 - Adding a single destination to a new room fails and then adds an arbitrary destination in an area not 				specified.

	CR100574 - BPS+48B panel group src select button does not tally correctly immediately following multiple changes 			of currently controlled dst.
	
	CR106527 - When there is no link status on EN2 the system will not let the user log into the Control Panel Server.


Known Issues(13)
	CR96877 - During an install the mibinfo.cmf may get deleted during an update, re-installing will resolve if the file 				gets deleted.

	CR105047 - Using Encore Internal frame count server, Trinix reports frame count reset error messages on console 				even if it gets getting same frame counts from both Encore controllers.

	CR113247 - All configured levels of a destination gets parked upon performing 'Release Users' operation from the 				TLM UI.

	CR113021 - In BPS and P48 panels, Level-Previous and Level-Next buttons get assigned with the 1st available level 			if no level is assigned to them in selection mode.

	CR113014 - All panel buttons of SCP does not blink when panel ID is performed.

	CR111543 - Setting the Server 1 and Server 2 IP address on a JEP-100 panel from the NetConfig UI is not 				supported, work around is to use the JEP 100 web page to set them.

	CR113698 - When BPS, KMD, P32 and P48 panels are in 'Chop' mode, 'Shift' button shall not be lit, although 				pressing the button performs the desired operation.

	CR112502 - Using an 8-level configuration using levels 25-32, the LRP source button does not light after a Take until 		the tally button next to level 25 (or level 26 to level 32 is pressed).

	CR113702 - The QC command will return the status as <undef> if the destination is Chopping.

	CR113102 - If an incorrect Alarm ID range is chosen then the response of for SB,AL,<Alarm ID Range1>,<Alarm 				ID Range2> is ER,BD instead of ER,BE.
	
	CR113065 - The Destination Select button remains in high tally even if the destination area is offline.

	CR113718 - The Previous and Next buttons on an Encore BPS panel that is not in self-config mode are incorrectly 				illuminated at high tally.

	CR103189 - If a Trinix matrix destination has never had a source selected on it, and that matrix board is removed 				from the frame, an UNDEF status is reported instead of NO XTP.

-----------------------------------------------------------------------------------------------
					CONCERTO
Fixed defects (2):
	CR106283 - In a concerto mono audio, If left from one source and right from another are taken to a destination, and 			if the two sources have different channel status blocks, the right channel's channel status block gets 		corrupted.

	CR107044 - TDM Redundancy does not work - the top TDM expansion pair stays active even when there is no 				signal.
Known Issues  (2):
	CR38431 -  Field/Frame Synchronous switching on Trinix and Concerto show 
		matrices are not switching on the same frame or same line (10.5 & 17.5).

	CR82548 - The output monitor will not work when the customer has 3 HD boards defined in the bottom 3 slots. It 				will work when the boards are configured in the top 3 slots 

-----------------------------------------------------------------------------------------------
			     		     Soft Panels
Fixed defects (2):
	CR107596 - Runtime error and failure to start when trying to open from a limited user account.

	CR108351 - Notification of Prelude not installed when running softpanels for Encore should be removed.
Known Issues  (0):
-----------------------------------------------------------------------------------------------
			 		Visual Status Display
Fixed defects (0):
Known Issues  (1):
	CR102338 - VSD shows the destination status as ‘NoStatus’ on performing RCE configuration ‘Save’ if RCE is 				 configured as Stand Alone.
	Workaround: Perform Commit Changes on the RCE.
-----------------------------------------------------------------------------------------------
			 	              Salvo Editor
Fixed defects (0):
Known Issues  (0):
-----------------------------------------------------------------------------------------------
			 	                Trinix
Fixed defects (3):
	CR65256 - Username/Password needs to be entered several times to login to the Broadlinx web page.

	CR109010 - Two 128 Trinix frames setup for 256x128, When Broadlinx in in frame 1 instead of frame 0, sources are 			offset by 128. When when swiching source 0 on frame 0, destination will flash source 128 briefly until the 			refresh comes in and source 0 will be switched.

	CR107497 - Monitor control failing - failures are different between control systems (Jupiter/Encore)

Known Issues  (1):
	CR113814 - Broadlinx won't work with certain brand of unmanaged switches.
-----------------------------------------------------------------------------------------------
			 	             7500 Matrices
Fixed defects (0):
Known Issues  (0):
-----------------------------------------------------------------------------------------------
			 	              NetConfig 2.0.12
Fixed defects (0):
Known Issues  (0):
-----------------------------------------------------------------------------------------------
			 	                 RCL GUI
Fixed defects (0):
Known Issues  (0):