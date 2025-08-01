/**********************************************************
    jep_100.c

    This program is used with RCM3200 series controllers
    with prototyping boards.

    The sample library, rcm3200.lib, contains a brdInit()
    function which initializes port pins. Modify this
    function to fit your application.

    An optional LCD/Keypad Module is required to run this
    program.  #define PORTA_AUX_IO at top of program to
    enable external I/O bus for LCD/Keypad operations.

    Description
    ===========
    This sample program demonstrates the use of the external
    I/O bus with the controller using an LCD/Keypad Module.
    The program will light-up an LED and will display a message
    on the LCD when a key press is detected.

*******************************************************************/
#class auto             // Change default storage class for local variables: on the stack


#ifdef USE_RELEASE_NET_CFG
  #define TCPCONFIG 100
#else
  #define TCPCONFIG 7
#endif

#define PORTA_AUX_IO    //required to run LCD/Keypad for this demo
#define UDP_SOCKETS 4	// allow enough for downloader and DHCP
#define MAX_UDP_SOCKET_BUFFERS 4
//#define TCPCONFIG 7
#define STDIO_DISABLE_FLOATS

#memmap xmem
#use "JP_100.lib"
#use "jpcfg.lib"
#use "display_chr4x8.lib"
#use "keypad128.lib"
#use "LED_MAX6954.LIB"
#use "serial.lib"
#use "dcrtcp.lib"

#use "UDPDOWNL.lib"
#use "gpi.lib"

/* Macro's used for RS422 testing */
#define mRS422_PASSED   0
#define mRS422_ERR_RXD  1   /* Could NOT receive data */
#define mRS422_ERR_TXD  2   /* Transmitt Enable line bad */

/* Macro's used for time measurement */
#define mSTART_TIME()   (startTime = MS_TIMER)
#define mSTOP_TIME()    (MS_TIMER - startTime)


/*  Function to do a Hardcore wait
** ------------------------------------------------------------------------ */
void    waitMs( unsigned long waitTimeMs );
void    waitMs( unsigned long waitTimeMs )
{
    unsigned long   startTime;

    startTime = MS_TIMER;
    while( (MS_TIMER - startTime) < waitTimeMs )   {;}
}

///////////////////////////////////////////////////////////////////////////
void main()
{
    unsigned long   startTime, runTime;

    unsigned int    nLedIndex, nKeyIndex, keyPressed, gpi;
    unsigned char   keydownflag, serialErrorStatus, dispKeyChar;
    unsigned char   myLedStatus[128];
    unsigned char   myCharData[8];
    unsigned char   myKeyData[8];
    unsigned char   serialRxByte;
    unsigned char   serialRxStatus;
    char   gpiIsEnabled;

    tcp_Socket socket;
    /* Initialize the arrays */
    memset( myLedStatus,0x00,sizeof(myLedStatus) ); // Clear LED array
    memset( myCharData,' ',sizeof(myCharData) );    //Reset Char Data

    //------------------------------------------------------------------------
    // Initialize the controller
    //------------------------------------------------------------------------
    jpBoardInit();
    serialInit(115200L);
    jpDispInit();
    jpLedInit();
    jpKeyInit();
    sock_init();
    UDPDL_Init("JEP-100 DIAGNOSTICS");

	jpGpiInit();

    dispKeyChar         = '0';
	keydownflag		    = FALSE;
	serialErrorStatus   = mRS422_PASSED;
	gpiIsEnabled = FALSE;

	jpDispWriteData(DSP_DSP1, "GPI?    " );
	jpDispWriteData(DSP_DSP2, "PRESS   ");
	jpDispWriteData(DSP_DSP3, "TAKE    ");

	while(1)
	  {
		if( jpKeyScanFast() )
		  {
			nKeyIndex = jpWhatKeyIsDown();
			if( nKeyIndex == 107 )
			  {
				gpiIsEnabled = TRUE;
			  }
			break;
		  }
		tcp_tick(NULL);
	  }

    /* Test LED display, Turn all led's on */
    jpLedEnterTestMode();
    waitMs( 2000L );
    jpLedExitTestMode();

    while(1)
    {
	tcp_tick(NULL);
	if (UDPDL_Tick())
	  {
	    jpDispWriteData(DSP_DSP1,"JEP-100 ");
	    jpDispWriteData(DSP_DSP2,"Pending ");
	    jpDispWriteData(DSP_DSP3,"Download");
	    jpDispWriteData(DSP_DSP4,"        ");
	    while (1)
	      {
		UDPDL_Tick(); // download new code.
	      }
	  }
        costate
        {
            waitfor(DelayMs(100));
            /* Check which button has been pressed */
			if( jpKeyScanFast() )
			  {
				nKeyIndex = jpWhatKeyIsDown();
				if( KEY_NA != nKeyIndex )
				  {
					keydownflag = TRUE;
					nKeyIndex++;	/* offset by 1 for display */
					sprintf(&myKeyData[0],"key  %3d",(int)nKeyIndex);
					jpDispWriteData(DSP_DSP1, &myKeyData[0] );
					jpLedSetOnOff( nKeyIndex -1, 1 );
					jpLedWriteOnOff();
					keyPressed = nKeyIndex -1;
				  }
			  }
			else if( gpiIsEnabled && jpScanGPI() )
			  {
					gpi = jpWhichGPIIsClosed();
					if( NO_OPTO != gpi )
					  {
						keydownflag = TRUE;
						gpi++;
						sprintf( &myKeyData[0], "gpi  %3d", gpi );
						jpDispWriteData(DSP_DSP1, &myKeyData[0] );
					  }
			  }
			else
			  {
				jpLedSetOnOff( keyPressed, 0 );
				jpLedWriteOnOff();
			  }
				
        }
        costate
        {
            waitfor(DelayMs(1000));
            memset( &myCharData[0], dispKeyChar, sizeof(myCharData) );
	    	if( FALSE == keydownflag )
	      	{
				jpDispWriteData(DSP_DSP1, &myCharData[0]);
	      	}
	      	if( mRS422_PASSED != serialErrorStatus )
	      	{
                jpDispWriteData(DSP_DSP2, "RS422 ER");

                if( mRS422_ERR_RXD == serialErrorStatus )
                {
                    jpDispWriteData(DSP_DSP3, "OffLine ");
                }
                else
                {
                    jpDispWriteData(DSP_DSP3, "TxEnable");
                }
	      	}
	      	else
	      	{
                jpDispWriteData(DSP_DSP2, &myCharData[0]);
                jpDispWriteData(DSP_DSP3, &myCharData[0]);
	      	}

            jpDispWriteData(DSP_DSP4, &myCharData[0]);

            if( ++dispKeyChar > '9' )   {dispKeyChar = '0';}
	    	keydownflag = FALSE;
		}
        costate
        {
            nLedIndex = 0;
            while(1)
            {
                if( nLedIndex != 0 )
                {
                    jpLedSetOnOff((nLedIndex - 1), 0); // Turn off previous LED
                }

                jpLedSetOnOff( nLedIndex, 1 );         // Turn On current LED
                jpLedWriteOnOff();
                waitfor(DelayMs(250));

                if( ++nLedIndex >= LED_NUMBER_OF_LEDS )
                {
                    memset( myLedStatus,0x01, sizeof(myLedStatus) );
                    jpLedWriteData(&myLedStatus[0]);
                    waitfor(DelayMs(1000));
                    break;
                }
            }

            nLedIndex = 0;
            while(1)
            {
                jpLedSetOnOff( nLedIndex, 0 );    //Off
                jpLedWriteOnOff();
                waitfor(DelayMs(250));

                if( ++nLedIndex >= LED_NUMBER_OF_LEDS )
                {
                    memset( myLedStatus,0x01, sizeof(myLedStatus) );
                    jpLedWriteData(&myLedStatus[0]);
                    waitfor(DelayMs(1000));
                    memset( myLedStatus,0x00, sizeof(myLedStatus) );
                    jpLedWriteData(&myLedStatus[0]);
                    break;
                }
            }
        }

        /* This test has been added to verify that the serial data can be
            Tx'd and Rx'd throught the serial port.  It also checks to make
            sure the "serialEnableTransmitter()" and
            "serialDisableTransmitter()" circuits work properly.
        ** ---------------------------------------------------------------- */
        costate
        {
            waitfor(DelayMs(500));

            /* Send a byte to the serial port */
            serialEnableTransmitter();
            serialSendByte(0x01);
            serialDisableTransmitter();

            /* Get the byte */
            serialSetTimeoutMilliseconds(10);
            serialRxStatus = serialReceiveByte( &serialRxByte );
            if( (SERIAL_OK != serialRxStatus)   ||
                (0x01 != serialRxByte)          )
            {
                serialErrorStatus = mRS422_ERR_RXD;
                abort;
            }

            /* Looks OK, now test that the transmitter is REALLY disabled */
            serialSendByte(0x02);
            serialSetTimeoutMilliseconds(10);
            serialRxStatus = serialReceiveByte( &serialRxByte );
            if( (SERIAL_TIMEOUT != serialRxStatus)  ||
                (0x02 == serialRxByte)			    )
            {
                serialErrorStatus = mRS422_ERR_TXD;
                abort;
            }

            /* All OK, show as good */
            serialErrorStatus = mRS422_PASSED;
        }
    }
}
