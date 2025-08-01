/*********************************************************************

 Filename:    opcTestSamples.cpp

 Description: Routines that show the steps needed for typical operations.
    The first set of functions use the commands of the Omneon Player Control api 
    to define a simple application that behaves like a vtr.

    At the bottom of the file are functions that list players and clips.

 Copyright (c) 1998-2001 Omneon Video Networks (TM)

 OMNEON VIDEO NETWORKS 

***********************************************************************/

/** include files **/
#define RESPONSE_CHECK       // time how long it takes motion to start
#ifdef RESPONSE_CHECK
#ifdef WIN32
#include <windows.h>        // needed for Sleep 
#else
#include <unistd.h>
#define Sleep(x) usleep((x)*1000)
#endif
#define RESPONSEWAIT 10     // sleep in units of milliseconds
#endif

#include "opctester.h"
#include <time.h>  // for "localtime" in listClips

/** local definitions **/
#define NUM_CMI_MS 4
struct ClipMapInfo {
    bool        valid;
    uint      firstFrame;
    uint      lastFrame;
    uint      defaultIn;
    uint      defaultOut;
    uint      numVideo;
    uint      numAudio;
    OmFrameRate   frameRate;
    bool        protection;
    bool        openForWrite;
    uint      creationTime;
    OmMediaSummary ms[NUM_CMI_MS];
};


/* default settings */
#define DEFAULT_RECORDLEN 900   // 30 seconds
#define DEFAULT_RECORDCLIP "TESTER_XCLIP"

/** external functions **/
// see opcTester.h

/** external data **/

/** public data **/
// none

/** private data **/
PRIVATE int xInit = 0;
PRIVATE char xRecordClip[omPlrMaxClipNameLen];
PRIVATE uint xRecordLen;

/** public functions **/
// most are 
bool Example_stop(FUNC_ARGS);       // also used locally
bool Example_load(FUNC_ARGS);
bool Example_create(FUNC_ARGS);

/** private functions **/
LOCAL void displayClipInfo (char *pDisplayStr, const char *pFormat, 
    const char *pClipName, const ClipMapInfo *cmi, bool doDate);
LOCAL OmPlrError updateClipInfo (OmPlrHandle OmPlrHand, const char *name, ClipMapInfo *cmi);




//++++++++++++++++++++++++++++++++++++++++++++++++++  from opctester.cpp


void InitForExamples(void)  
{
    xInit++;        // set it non zero
    xRecordLen = DEFAULT_RECORDLEN;
    strcpy(xRecordClip, DEFAULT_RECORDCLIP);
}


/*
Load a clip onto the timeline and prep it for recording.
Clip must not already exist (query about OVERWRITE y/n)
First unload all previously attached clips
Optionally accept a clipname and a duration.
If not provided, then use defaults

create [ clipName [duration ]]

NOTE: IF the input signal is not present yet, the cueRecord will fail.
  In that case, the xRecord command will provide the CueRecord (and some extra delay)
*/
bool Example_create(FUNC_ARGS)
{
    OmPlrError      error;
    uint            clipLen;
    char *          pClipName = 0;
    OmPlrStatus     status;
    OmPlrClipHandle clipHandle;
    bool exists;

    if (xInit == 0)  {
        InitForExamples();  // set up record defaults
        // sets gInit to nonZero
    }

    // parse the command arguments -- for use below
    clipLen = xRecordLen;   // default if needed below (after initialization)
    if (numWords >  1)  {
        pClipName = word[1];
        if(numWords > 2) {
            clipLen = strtol (word[2], 0, 0);
        }
    }

    OmPlrStop (gPlrHand);
    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if ((error != 0) || (status.state != omPlrStateStopped))  {
        errMsg("failed to put player into STOP state from play\n");
        return(true);
    }

    // If not given a specific clip name
    //    then set up for crash record into XTESTER_clip
    if (pClipName == 0) {
        pClipName = xRecordClip;
    } 
    

    // remove all clips from timeline
    // (may be redundant) (may be removing "this" clip if it already exists)
    OmPlrDetachAllClips (gPlrHand);

    // see if the clip has already been recorded
    error = OmPlrClipExists(gPlrHand, pClipName, &exists);
    if (error != 0)  {
        errMsg("failure checking existence of \"%s\": %s",
                pClipName, showError(error));
        return(true);
    }
    if (exists)  {
        char        input[128];

        msg("clip \"%s\" already exists.  Overwrite it? (Y/N) ", pClipName);
        fgets (input, sizeof (input), stdin);
        if (input[0] != '\n')
            msg("\n\n");
        if ((input[0] != 'y') && (input[0] != 'Y'))   {
            gError = (OmPlrError)32;     // so can be used by xRecord
            return(true);
        }
        OmPlrClipDelete(gPlrHand, pClipName);
    }

    // Attach the new clip -- creates the file structure.
    error = OmPlrAttach (gPlrHand, pClipName, /*clipIn*/ 0, /*clipOut*/ clipLen, 
        /*attachBeforeClip*/ 0, omPlrShiftModeAfter, &clipHandle);
    if (error) {
        errMsg("failed to load %s on player %s  %s\n", pClipName,
                gPlrName, showError (error));
        gError = (OmPlrError)31;     // so can be used by xRecord
        return true;
    }

    // Set timeline MIN/MAX using the "to be created" clip
    OmPlrSetMinPosMin (gPlrHand);
    OmPlrSetMaxPosMax (gPlrHand);


    // Setup to start recording at the beginning
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s  %s\n", gPlrName,
                showError (error));
        return true;
    }
    OmPlrSetPos (gPlrHand, status.minPos);

    error = OmPlrCueRecord (gPlrHand);
    if (error) {
        errMsg("player %s failed to enter cue record state   %s\n",
                gPlrName, showError (error));
    }
    msg("Prepared new clip \"%s\" for recording; len = %d\n",
        pClipName, clipLen);
    return(true);
}    

/*
Used if want to record a series of clips.
Normally there was a call to CREATE before this
Can be called while in CueRecord or Record state 
  (or STOP if currClip is empty)
Doesn't alter player motion state (ie -- no attempt to get from Stop to CUeRecord)
*/
bool Example_createNext(FUNC_ARGS)
{
    OmPlrError   error;
    uint            clipLen;
    char *          pClipName = 0;
    OmPlrStatus     status;
    OmPlrClipHandle clipHandle;
    bool exists;

    if (xInit == 0)  {
        InitForExamples();  // set up record defaults
        // sets gInit to nonZero
    }

    // parse the command arguments -- for use below
    clipLen = xRecordLen;   // default if needed below (after initialization)
    if (numWords >  1)  {
        pClipName = word[1];
        if(numWords > 2) {
            clipLen = strtol (word[2], 0, 0);
        }
    }

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return (true);
    }
    if ((status.state == omPlrStateCueRecord) || (status.state == omPlrStateRecord)) {
        ; // ok -- proceed
    } else if (status.numClips == 0) {
        ; // ok -- proceed
    } else if  (status.currClipFirstFrame == status.currClipLastFrame)  {
        ; // ok -- proceed
    } else {
        errMsg("improper recording/timeline state for createNext - abort\n");
        gError = (OmPlrError)35;
        return(true);
    }
        
    //    then set up for crash record into XTESTER_clip
    if (pClipName == 0) {
        pClipName = xRecordClip;
    } 
    
    // see if the clip has already been recorded
    error = OmPlrClipExists(gPlrHand, pClipName, &exists);
    if (error != 0)  {
        errMsg("failure checking existence of \"%s\": %s",
                pClipName, showError(error));
        return(true);
    }
    if (exists)  {
        char        input[128];

        msg("clip \"%s\" already exists.  Overwrite it? (Y/N) ", pClipName);
        fgets (input, sizeof (input), stdin);
        if (input[0] != '\n')
            msg("\n\n");
        if ((input[0] != 'y') && (input[0] != 'Y'))   {
            gError = (OmPlrError)32;     // so can be used by xRecord
            return(true);
        }
        OmPlrClipDelete(gPlrHand, pClipName);
    }

    // Attach the new clip -- creates the file structure.
    error = OmPlrAttach (gPlrHand, pClipName, /*clipIn*/ 0, /*clipOut*/ clipLen, 
        /*attachBeforeClip*/ 0, omPlrShiftModeAfter, &clipHandle);
    if (error) {
        errMsg("failed to load %s on player %s  %s\n", pClipName,
                gPlrName, showError (error));
        return true;
    }

    // Set timeline MAX using the "to be created" clip
    OmPlrSetMaxPosMax (gPlrHand);


    msg("Prepared additional new clip \"%s\" for recording; len = %d\n",
        pClipName, clipLen);
    return(true);
    
}    
        
  
bool Example_eject(FUNC_ARGS)
{
    // stop the player.
    // detach all clips.
    // Set min/max/pos back to 0
    // cancel loop mode.
    OmPlrStop(gPlrHand);
    OmPlrDetachAllClips(gPlrHand);
    OmPlrSetMinPos(gPlrHand, 0);
    OmPlrSetMaxPos(gPlrHand, 0);
    OmPlrSetPos(gPlrHand, 0);
    OmPlrLoop(gPlrHand, 0, 0);
    return(true);
}    

/*
Goto a position within the CURRENT clip (or in a specified clip)
 -- the argument is a CLIP relative number.
 Example -- a clip has 1st frame = 0 and lastFrame = 900.
 It is attached at timeline location = 0, but with an IN of 100 and an OUT of 200.
 (remember that IN and OUT are relative to the clip).
 SO a goto with an argument of 150 will go 50 frames into the clip.
 If the argument exceeds the limit of the current clip, the arg will be trimmed so that it 
 stays within the current clip.

 MOtion will be play -- with a rate of 0.0 (ie, still/pause)
 NOT allowed if recording is happening.
 NOT allowed if the clip is not already attached.
*/
bool Example_goto(FUNC_ARGS)
{
    OmPlrStatus     status;
    OmPlrError  error;
    uint  clipTarget;
    int   timelineTarget;
    OmPlrClipHandle  clipHandle;
    int   clipIndex;
    int   attachPosition;
    uint  clipIn;
    uint  clipOut;

    if (numWords < 2)  {
        return(false);  // don't have the position parm
    }
    // Accept optional clip Number (or handle)
   if (numWords > 2)  {
        if (!mapClipIndexToHandle(word[1], &clipHandle, &clipIndex) )  {
                return(false);
        }
        clipTarget = strtol(word[2],0,0);
    } else {
        clipHandle = 0;
        clipTarget = strtol(word[1],0,0);
    }

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return (true);
    }
    if ((status.state == omPlrStateCueRecord) || (status.state == omPlrStateRecord)) {
        errMsg("not allowed while RECORDING \n");
        // NOTE: an error will be returned if you continue
        return (true);
    }
    if (status.numClips == 0)      {
        errMsg("Silly if no clips are attached -- abort\n");
        return (true);
    }

    // set mode to play at 0.0  (handles getting clip from stop to play if necessary
    if (status.state == omPlrStateStopped) {
        error = OmPlrCuePlay (gPlrHand, 0.0);
        if (error) {
            errMsg("failed to cue play player %s  %s\n", gPlrName,
                    showError (error));
            return true;
        }
    }
    error = OmPlrPlay(gPlrHand, 0.0);
    if (error) {
        errMsg("player %s failed to go into play:  %s\n", gPlrName,
                showError(error));
        return (true);
    }



    // If not given clip, convert "current Clip" info into a handle
    if (clipHandle == 0)  {
        error = OmPlrGetPlayerStatus (gPlrHand, &status);
        if (error) {
            errMsg("failed to get status:   %s\n", gPlrName,
                    showError(error));
            return (true);
        }
        clipIndex = status.currClipNum;
        error = OmPlrGetClipAtNum( gPlrHand, clipIndex, &clipHandle);
        if (error) {
            errMsg("failed to get clipHandle at num %d:   %s\n", status.currClipNum,
                    showError(error));
            return (true);
        }
    }
        
    // check target against min/max of clip
    error = OmPlrGetClipData( gPlrHand, clipHandle, &attachPosition, &clipIn, &clipOut, /*clipLen*/ 0);
    if (error) {
        errMsg("failed to get clip data:   %s\n", showError(error));
        return (true);
    }
    if (clipTarget < clipIn)  {
        clipTarget = clipIn;
    } else if (clipTarget > clipOut -1)  {
        clipTarget = clipOut -1;
    }
    
    // convert target from clipReferenced to Timeline Referenced
    // check that timeline min/max allow setting of "this" position
    timelineTarget = attachPosition+clipTarget-clipIn;
    if (status.minPos > timelineTarget)  {
        OmPlrSetMinPos( gPlrHand, timelineTarget);
        msg ("adjusted timeline minimum to %d so can reach target\n", timelineTarget);
    }
    if (timelineTarget >= status.maxPos)  {
        OmPlrSetMaxPos( gPlrHand, timelineTarget+1);
        msg ("adjusted timeline maximum to %d so can reach target\n", timelineTarget+1);
    }

    // set position
    error = OmPlrSetPos( gPlrHand, timelineTarget);
    if (error) {
        errMsg("failed to get clip data:   %s\n", showError(error));
    } else {
        msg("Set timeline position to that it is at %d inside clip index %d\n",
                clipTarget, clipIndex);
    }
    return(true);
}    


/*
Load one clip onto the timeline.  Use default in/out points
First make sure that the clip already exists and that it is not empty.
First detach all others.
Leave motion state undefined.
Set min/max on this clip.  Set pos to the start of this clip
*/
bool Example_load(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrStatus     status;
    OmPlrClipHandle clipHandle;
    char            * pClipName;
    OmPlrClipInfo   clipInfo;
    OmMediaSummary  ms[NUM_CMI_MS];


    if (numWords < 2)   {
        errMsg("clip name not supplied for LOAD\n");
        return(false);
    }
    pClipName = word[1];

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return(true);
    }

    if ((status.state == omPlrStateRecord) || (status.state == omPlrStateCueRecord)) {
        errMsg("Not allowed while recording -- abort\n");
        gError = (OmPlrError)29;      // so that other examples can use this
        return(true);
    }

    // get clip information
    clipInfo.maxMsTracks = NUM_CMI_MS;
    clipInfo.ms = ms;
    error = OmPlrClipGetInfo (gPlrHand, pClipName, &clipInfo);
    if (error == omPlrInvalidClip) {
        errMsg("Clip \"%s\" does not exist -- abort \n", pClipName);
        gError = (OmPlrError)23;        // so that other examples can use this
        return(true);
    }
    // else 
    if (error) {
        errMsg("failed to get  clip info for \"%s\": %s\n", pClipName,
                showError(error));
        return(true);
    }
    // else 
    if (clipInfo.firstFrame == clipInfo.lastFrame) {
        errMsg("clip \"%s\" is empty -- abort\n", pClipName);
        gError = (OmPlrError)23;        // so that other examples can use this
        return(true);
    }


    OmPlrDetachAllClips(gPlrHand);
    error = OmPlrAttach (gPlrHand, pClipName, omPlrClipDefaultIn, omPlrClipDefaultOut, 
        /*attachBeforeClip*/ 0, omPlrShiftModeAfter, &clipHandle);
    if (error) {
        errMsg("failed to get load clip \"%s\": %s\n", pClipName,
                showError(error));
        return(true);
    }

    // Set timeline MIN/MAX and POS using the newly loaded clip
    OmPlrSetMinPosMin (gPlrHand);
    OmPlrSetMaxPosMax (gPlrHand);

    status.minPos = 0;       // in case of error, will use this value
    OmPlrGetPlayerStatus (gPlrHand, &status);
    OmPlrSetPos (gPlrHand, status.minPos);

    msg("loaded clip \"%s\" onto timeline\n", pClipName);
    return (true);    
}    

/*
Illegal if recording
same as _load except doesn't do a detach.
Make sure that the clip exists and is not empty (use ClipGetInfo1)
Append the clip.
*/
bool Example_loadNext(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle clipHandle;
    OmPlrStatus     status;
    char            * pClipName;
    OmPlrClipInfo   clipInfo;
    OmMediaSummary  ms[NUM_CMI_MS];


    if (numWords < 2)   {
        errMsg("clip name not supplied for LOAD\n");
        return(false);
    }
    pClipName = word[1];

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return(true);
    }

    if ((status.state == omPlrStateRecord) || (status.state == omPlrStateCueRecord)) {
        errMsg("Not allowed while recording -- abort\n");
        gError = (OmPlrError)29;      // so that other examples can use this
        return(true);
    }

    // get clip information
    clipInfo.maxMsTracks = NUM_CMI_MS;
    clipInfo.ms = ms;
    error = OmPlrClipGetInfo(gPlrHand, pClipName, &clipInfo);
    if (error == omPlrInvalidClip) {
        errMsg("Clip \"%s\" does not exist -- abort \n", pClipName);
        gError = (OmPlrError)23;        // so that other examples can use this
        return(true);
    }
    // else 
    if (error) {
        errMsg("failed to get  clip info for \"%s\": %s\n", pClipName,
                showError(error));
        return(true);
    }
    // else 
    if (clipInfo.firstFrame == clipInfo.lastFrame) {
        errMsg("clip \"%s\" is empty -- abort\n", pClipName);
        gError = (OmPlrError)23;        // so that other examples can use this
        return(true);
    }


    // Attach the clip onto the timeline -- after all other previously attached clips
    error = OmPlrAttach (gPlrHand, pClipName, omPlrClipDefaultIn, omPlrClipDefaultOut, 
        /*attachBeforeClip*/ 0, omPlrShiftModeAfter, &clipHandle);
    if (error) {
        errMsg("failed to get load clip \"%s\": %s\n", pClipName,
                showError(error));
        return(true);
    }

    // Set timeline MAX using the newly loaded clip
    OmPlrSetMinPosMin (gPlrHand);
    msg("loaded clip \"%s\" onto timeline\n", pClipName);
    return (true);    
}

/*
Optionally give it the name of a clip.
  If a clip is to be loaded, then eject all others and set timeline up on this one.
Put the timeline into motion at 1X speed.
If issued while recording -- do a stop and a rewind
*/
bool Example_play(FUNC_ARGS) 
{
    OmPlrError   error;
    OmPlrStatus     status;

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        status.state = omPlrStateStopped;
    }

    if ((status.state == omPlrStateRecord) || (status.state == omPlrStateCueRecord)) {
        gError = (OmPlrError)0;
        
        // Stop recording; set position back to start of timeline
        Example_stop(numWords, word);        
        if (gError != 0)  {
            errMsg("aborting PLAY function -- can't stop\n");
            return(true);
        }
        OmPlrGetPlayerStatus (gPlrHand, &status);
    }

    // Handle the clip name -- load it if specified
    // (note: does not change motion state; will change position)
    if (numWords >  1)  {
        gError = (OmPlrError)0;
        Example_load(numWords, word);
        if (gError != 0)  {
            errMsg("aborting PLAY function \n");
            return(true);
        }
        OmPlrGetPlayerStatus (gPlrHand, &status);      //  to get updated position info
    }

    // Get timeline ready for play (note: this function only runs at 1X speed)
    if (status.state == omPlrStateStopped) {
        error = OmPlrCuePlay (gPlrHand, /*rate*/ 1.0);
        if (error) {
            errMsg("failed to cue play player %s  %s\n", gPlrName,
                    showError (error));
            return true;
        }
    }

    // Put timeline into play (note: this function only runs at 1X speed)
    error = OmPlrPlay (gPlrHand, /*rate*/ 1.0);
    if (error)
        errMsg("failed to play player %s   %s\n", gPlrName,
                showError (error));
    else
        msg("player %s started at 1X speed\n", gPlrName);

#ifdef RESPONSE_CHECK
    {
        int wasTimelinePosition = status.pos;
        int i;
        for (i = 0;wasTimelinePosition == status.pos ; i++) {
            if (i > 50)  {
                msg(" -- give up waiting for movement\n");
                i = -1;
                break;
            }
            Sleep (RESPONSEWAIT);     // in units of milliSeconds
            OmPlrGetPlayerStatus (gPlrHand, &status);
        }
        if (i >= 0)
            msg("-- position changed after %d milliseconds \n", i*RESPONSEWAIT);
        
    }
#endif
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if ((error == 0) && (status.pos >= status.maxPos-1)) {
        msg("   Warning -- timeline already at maximum position\n");
    }
    return true;
}


// usage: record [clipName [numFrames ]]
bool Example_record(FUNC_ARGS)
{
    OmPlrError   error;
    OmPlrStatus     status;


    // Make some decisions based on current state of the player
    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s  %s\n", gPlrName,
                showError (error));
        return true;
    }

    if (status.state == omPlrStateRecord)  {
        msg("Already recording; do nothing\n");
        return(true);
    }


    // If no clips are loaded, then load one
    // IF the loaded clips are not empty, then flush and load one
    if ((status.numClips == 0) || 
        (status.currClipFirstFrame != status.currClipLastFrame) ) {
        gError = (OmPlrError)0;
        Example_create(numWords, word);
        if (gError != 0) {
            errMsg("unable to create new clip -- aborting RECORD\n");
            return(true);
        }
    }

    // Get fresh status for the player
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s  %s\n", gPlrName,
                showError (error));
        return true;
    }
    if (status.state != omPlrStateCueRecord) {
        if (status.state != omPlrStateStopped) {
            OmPlrStop (gPlrHand);
            error = OmPlrGetPlayerStatus (gPlrHand, &status);
            if ((error != 0) || (status.state != omPlrStateStopped))  {
                errMsg("failed to put player into STOP state from play\n");
                return(true);
            }
        }

        // Ready for record;  blocks here until ready and input has been seen.
        error = OmPlrCueRecord (gPlrHand);
        if (error) {
            errMsg("player %s failed to enter cue record state   %s\n",
                    gPlrName, showError (error));
            return true;
        }
    }

    error = OmPlrRecord (gPlrHand);
    if (error)  {
        errMsg("player %s failed to enter record state   %s\n",
                gPlrName, showError (error));
    } else {
        uint timelineLen = status.maxPos - status.minPos;
        uint clipLen = status.currClipOut - status.currClipIn;

        msg("Started recording -- clip \"%s\" for %d frames & total of %d frames\n",
                status.currClipName, clipLen, timelineLen);
    }
    return true;
}

/*
Illegal if recording
Error if no clip attached.
Clamp speed so that limits are not exceeded
Start moving at a signed speed.
Warn if already at the limit
*/
bool Example_shuttle(FUNC_ARGS)
{
#define MAXRATE 128.0       // serves at both positive and negative limits
    OmPlrStatus     status;
    OmPlrError  error;
    double rate;
    if (numWords < 2)  {
        return(false);  // don't have the speed parm
    }
    sscanf (word[1], "%lf", &rate);

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return (true);
    }
    if ((status.state == omPlrStateCueRecord) || (status.state == omPlrStateRecord)) {
        errMsg("not allowed while RECORDING \n");
        // NOTE: an error will be returned if you continue
        return (true);
    }
    if (status.numClips == 0)      {
        errMsg("rather silly if no clips are attached\n");
    }

    // limit rate so that it always works
    if (rate > MAXRATE)  {
        rate = MAXRATE;
    } else if (rate < -MAXRATE)  {
        rate = -MAXRATE;
    }

    if (status.state == omPlrStateStopped) {
        error = OmPlrCuePlay (gPlrHand, rate);
        if (error) {
            errMsg("failed to cue play player %s  %s\n", gPlrName,
                    showError (error));
            return true;
        }
    }
    error = OmPlrPlay(gPlrHand, rate);
    if (error) {
        errMsg("player %s failed to go into play:  %s\n", gPlrName,
                showError(error));
        return (true);
    }
    // else
    msg("Set player speed at %5.2f\n", rate);

    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error == 0)  {
        if ((rate > 0) && (status.pos >= status.maxPos-1))      {
            msg("   Warning -- timeline already at maximum position\n");
        } else if ((rate < 0) && (status.pos == status.minPos))      {
            msg("   Warning -- timeline already at minimum position\n");
        }
    }
    return true;
}    



//++++++++++++++++++++++++++++++++++++++++++++++++++

/*
Slam the position back to minimum
If state is play, set rate at 0.0
Illegal if recording
No change of state
*/
bool Example_slam(FUNC_ARGS)
{
    OmPlrStatus     status;
    OmPlrError  error;
    
    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return (true);
    }
    if ((status.state == omPlrStateCueRecord) || (status.state == omPlrStateRecord)) {
        errMsg("not allowed while RECORDING \n");
        return (true);
    }
    if (status.state == omPlrStatePlay)  {
        OmPlrPlay(gPlrHand, 0.0);
    }
    OmPlrSetPos(gPlrHand, status.minPos);
    msg("timeline position set to %d\n", status.minPos);
    return(true);
}    

/*
Illegal if recording
Error if no clip attached.
Warn if already at the limit
*/
bool Example_step(FUNC_ARGS)
{
     OmPlrStatus   status;
    OmPlrError  error;
    int          step;
    int          wasTimelinePosition;

    if (numWords < 2)  {
        return(false);  // don't have the speed parm
    }
    step = strtol(word[1], 0, 0);

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return (true);
    }
    if ((status.state == omPlrStateCueRecord) || (status.state == omPlrStateRecord)) {
        errMsg("not allowed while RECORDING \n");
        // NOTE: an error will be returned if you continue
        return (true);
    }
    if (status.numClips == 0)      {
        errMsg("rather silly if no clips are attached\n");
    }

    if (status.state == omPlrStateStopped){
        error = OmPlrCuePlay (gPlrHand, 0.0);
        if (error) {
            errMsg("failed to put player into CuePlay state:  %s\n", 
                    showError (error));
            return true;
        }
        // else
        status.state = omPlrStateCuePlay;       // if succeeded
    }
    if (status.state == omPlrStateCuePlay){
        error = OmPlrPlay (gPlrHand, 0.0);
        if (error) {
            errMsg("failed to put player into still state:  %s\n", 
                    showError (error));
            return true;
        }
    }

    // Test to see if already sitting at a limit
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error == 0)  {
        if ((step > 0) && (status.pos >= status.maxPos-1))      {
            msg("   Warning -- timeline already at maximum position\n");
        } else if ((step < 0) && (status.pos == status.minPos))      {
            msg("   Warning -- timeline already at minimum position\n");
        }
    }

    // Move the timeline position
    error = OmPlrStep(gPlrHand, step);
    if (error) {
        errMsg("player %s failed to step:  %s\n", gPlrName,
                showError(error));
        return (true);
    }
    // else

    // Get new position; Test to see if is now sitting at a limit
    wasTimelinePosition = status.pos;

#ifdef RESPONSE_CHECK
    int i;
    for (i = 0;(step != 0) && (wasTimelinePosition == status.pos) ; i++) {
        if (i > 50)  {
            msg("-- give up waiting for movement\n");
            i = -1;
            break;
        }
        Sleep (RESPONSEWAIT);     // in units of milliSeconds
        status.size = sizeof(OmPlrStatus);
        OmPlrGetPlayerStatus (gPlrHand, &status);
    }
    if (i >= 0)
        msg("FIXME -- position changed after %d milliseconds \n", i*RESPONSEWAIT);
#endif
    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error == 0)  {
        msg ("Stepped player by %d steps; asked to move %d steps\n",
                status.pos - wasTimelinePosition, step);
        if ((step > 0) && (status.pos >= status.maxPos-1))      {
            msg("   Warning -- timeline now at at maximum position\n");
        } else if ((step < 0) && (status.pos == status.minPos))      {
            msg("   Warning -- timeline now at at minimum position\n");
        }
    } else {
        errMsg("unable to get new status after stepping the player");
    }

    return true;
}

/*
if recording -- do a stop first
Error if no clip attached.
*/
bool Example_still(FUNC_ARGS)
{
    OmPlrStatus     status;
    OmPlrError  error;

    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get status for player %s   %s\n", gPlrName,
                showError(error));
        return (true);
    }
    if ((status.state == omPlrStateCueRecord) || (status.state == omPlrStateRecord)) {
        // Stop the recording process
        Example_stop(/*numWords*/ 0, word);
    }

    if (status.numClips == 0)      {
        errMsg("rather silly if no clips are attached\n");
    }

    // Several choices here.  
    //  If already cued or playing, could use OmPlrStep or OmPlrPlay at 0.0
    //  Or OmPlrCuePlay works from either stop or play
    if (status.state == omPlrStateStopped) {
        error = OmPlrCuePlay (gPlrHand, 0.0);
        if (error) {
            errMsg("failed to cue play player %s  %s\n", gPlrName,
                    showError (error));
            return true;
        }
    }
    error = OmPlrPlay(gPlrHand, 0.0);
    if (error) {
        errMsg("player %s failed to go into play:  %s\n", gPlrName,
                showError(error));
        return (true);
    } else {
        msg("player is in PLAY state at a speed of 0.0\n");
    }
    return true;
}


bool Example_stop(FUNC_ARGS)
{
    OmPlrError   error;
    OmPlrState       state;

    state = omPlrStateStopped;    // in case of error -- will go on anyway
    OmPlrGetState (gPlrHand, &state);

    error = OmPlrStop (gPlrHand);
    if (error)
        errMsg("failed to stop player %s   %s\n", gPlrName,
                OmPlrGetErrorString (error));
    else
        msg("player %s stopped\n", gPlrName);

    // set the clipout position
    if (state == omPlrStateCueRecord || state == omPlrStateRecord) {
        // any clips attached??
        uint numClips;
        error = OmPlrGetNumClips (gPlrHand, &numClips);

        if (numClips) {
            uint clipIn;

            // Update last clip -- as attached to timeline.
            // Preserve its IN point but set its OUT to match last recorded frame.
            error = OmPlrGetClipData (gPlrHand, omPlrLastClip, 0,
                                    &clipIn, 0, 0);
            if (!error)
                OmPlrSetClipData (gPlrHand, omPlrLastClip, clipIn,
                                omPlrClipDefaultOut,
                                omPlrClipDefaultLen, omPlrShiftModeAuto);
            // Update timeline limits to exactly match 1st and last clip
            OmPlrSetMinPosMin (gPlrHand);
            OmPlrSetMaxPosMax (gPlrHand);
        }
    }
    return true;
}



bool Example_listAttachedClips(FUNC_ARGS)       // SAMPLE function
{
    extern bool getPlayerStatus(FUNC_ARGS);

    const char      header1[] =
        "number           path                     name         attachAt   in     out  \n";
    const char      header2[] =
        "==== =========================== ===================== ========  ====== ======\n";
    const char      fmt[] = "% 4d %-27s %-21s % 8d % 6d % 6d\n";

    OmPlrError   error;
    int   i;
    OmPlrStatus     status;
    OmPlrClipHandle  hAttachedClip;
    char  clipName[omPlrMaxClipNameLen];
    char  clipPath[omPlrMaxClipDirLen];
    int   attachPoint;
    uint  attachedIn;
    uint  attachedOut;

    // Show the player status first
    getPlayerStatus(numWords, word);

    // then show the clips on the timeline
    status.size = sizeof(OmPlrStatus);
    error = OmPlrGetPlayerStatus(gPlrHand, &status);
    if (error) {
        errMsg("failed to get player status %s\n",
                showError(error));
        return true;
    }
    
    if (status.numClips == 0) {
        msg("\nThere are no clips attached to the timeline\n");
        return(true);
        
    }

    msg(header1);
    msg(header2);
    for (i = 0; i < (int)status.numClips; i++) {
        error = OmPlrGetClipAtNum (gPlrHand, i, &hAttachedClip);
        error = OmPlrGetClipName (gPlrHand, hAttachedClip, clipName, omPlrMaxClipNameLen);
        error = OmPlrGetClipPath (gPlrHand, hAttachedClip, clipPath, omPlrMaxClipDirLen);
        error = OmPlrGetClipData (gPlrHand, hAttachedClip, &attachPoint, &attachedIn, &attachedOut,
                                /*length */ 0);
        msg(fmt, i, clipPath, clipName, attachPoint, attachedIn, attachedOut);
    }

    msg("\n   Total of %d clips \n", status.numClips);
    return(true);
}    


bool Example_listClips(FUNC_ARGS)       // SAMPLE function
{
    const char      header1[] =
        "name                  in/len,first/len     ";
    const char      header2[] =
        "===================== ==================== =====================\n";
    const char      fmt[] = "%-20s%c %-20s %-21s\n";

    bool doDate = false;
    int lines = 2;
    int numClips = 0;
    int numInvalidClips = 0;
    int dispLines;

    OmPlrError       error;
    uint num;        // number of clips from GetFirst/GetNext
    char clipName[omPlrMaxClipNameLen];

    ClipMapInfo cmi;
    char lastStr[80];
    char invalidStr[64];

    num = 1;
    error = OmPlrClipGetFirst (gPlrHand, clipName, omPlrMaxClipNameLen);
    if (error == omPlrEndOfList)  {
        msg("No clips exist in current directory\n");
        return true;
    }
    if (error) {
        errMsg("failed to get name of first clip: %s\n",
                showError (error));
        return true;
    }

    msg(header1);
    if (doDate)
        msg("created\n");
    else
        msg("type\n");
    msg(header2);
             
    dispLines = gHeight;
    if (dispLines < 0)
        dispLines = 0;


    while (1) {
        error = updateClipInfo(gPlrHand, clipName, &cmi);

        if (!error)  {
            displayClipInfo(lastStr, fmt, clipName, &cmi, doDate);
            lines++;
            numClips++;
        }  else  {
            msg("%-22s%s\n", clipName, showError (error));
            lines++;
            numInvalidClips++;
        }

        if (gInteractive && (dispLines > 0) && (lines >= dispLines)) {
            lines = 0;
            if (!pauseForKeyPress()) return true;
        }

        error = OmPlrClipGetNext (gPlrHand, clipName, omPlrMaxClipNameLen);
        if (error) {
            if (error != omPlrEndOfList)  {
                errMsg("failed to get name of next clip: %s\n",
                        showError (error));
            }
            break;
        }
    }

    if (numInvalidClips)
        sprintf(invalidStr, " (%d invalid clips)", numInvalidClips);
    else
        invalidStr[0] = 0;
    if (numClips)
        msg("total of %d clips %s\n", numClips, invalidStr);

    return true;
}


bool Example_listPlayers(FUNC_ARGS)                // SAMPLE function  
{
    OmPlrError   error;
    char selectedName[omPlrMaxPlayerNameLen];
    OmPlrHandle hSelectedPlayer = 0;

    const char      header[] = "\n"
        "Name             position state      frRate cont  clips n:pos/len \n"
        "================ ======== ========== ====== ===== =============== \n";
    const char      fmt[] ="%-16s %-8d %-10s %-6s %-5s %-15s \n";


    error = OmPlrGetFirstPlayer (gPlrHand, selectedName, omPlrMaxPlayerNameLen);

    msg(header);

    while (error == 0) {
        OmPlrStatus status;
        bool autoFrameRate;
        OmFrameRate frameRate;
        double freq;
        OmPlrApp playerApp;
        int firstPos;
        int lastPos;

        char state[32];
        char frameRateStr[8];
        char nameStr[32];
        char appStr[32];
        char clipStr[32];
        char enableChar;

        error = OmPlrOpen(gDirName, selectedName, &hSelectedPlayer);
        if (error != 0) {
            errMsg("Unable to select player \"%s\"\n", selectedName);
            return (true);
        }

        status.size = sizeof(OmPlrStatus);
        error =  OmPlrGetPlayerStatus (hSelectedPlayer, &status);
        if (error)
            memset (&status, 0, sizeof (status));

        state[0] = 0;

        if (status.state == omPlrStatePlay)
            sprintf (state + strlen(state), "play %4.1f", status.rate);
        else
            strcat (state, stateStr (status.state));

        // generate the name string
        if (status.playEnabled && status.recordEnabled)
            enableChar = ' ';
        else if (status.playEnabled)
            enableChar = 'P';
        else if (status.recordEnabled)
            enableChar = 'R';
        else
            enableChar = 'D';
        sprintf (nameStr, "%-15s%c", selectedName, enableChar);

        // generate video frameRate string
        autoFrameRate = (((uint)status.frameRate & 0x10000) != 0);
        frameRate = (OmFrameRate)((uint)status.frameRate &
                                          0xffff);
        switch (frameRate) {
        case omFrmRate24Hz: freq = 24.0; break;
        case omFrmRate25Hz: freq = 25.0; break;
        case omFrmRate29_97Hz: freq = 29.97; break;
        default: freq = 0.0;
        }
        sprintf (frameRateStr, "%g%c", freq, autoFrameRate ? 'A' : ' ');

        error = OmPlrGetApp (hSelectedPlayer, &playerApp);
        if (error) playerApp = omPlrAppNone;

        sprintf(appStr, "%s", printApp(playerApp));

        if (status.numClips > 0) {
            firstPos = status.firstClipStartPos;
            lastPos = status.lastClipEndPos;
        }
        else {
            firstPos = 0;
            lastPos = 0;
        }

        sprintf (clipStr, "%d:%d/%d%s", status.numClips, firstPos,
                 lastPos - firstPos,
                 (status.loopMin == status.loopMax) ? "" : "L");

        msg(fmt, nameStr, status.pos, state, frameRateStr, appStr,
             clipStr);
        error = OmPlrGetNextPlayer (gPlrHand, selectedName, omPlrMaxPlayerNameLen);
    }

    if (hSelectedPlayer != 0) {
        error = OmPlrClose (hSelectedPlayer);
        if (error != 0){
            errMsg("trouble closing handle to selected player \"%s\"\n", selectedName);
        }
    }

    msg("\n");
    return true;
}

LOCAL void displayClipInfo (char *pDisplayStr, const char *pFormat, 
    const char *pClipName, const ClipMapInfo *cmi, bool doDate)
{
    char lengthStr[32];

    char *ptr = pDisplayStr;
    *ptr = 0;

    sprintf (lengthStr, "%d/%d,%d/%d",
             cmi->defaultIn,
             cmi->defaultOut - cmi->defaultIn,
             cmi->firstFrame,
             cmi->lastFrame - cmi->firstFrame);

    if (!doDate) {
        // start with video frameRate
        char *freqStr;
        if (cmi->frameRate == omFrmRate25Hz) freqStr = "25.00Hz";
        else if (cmi->frameRate == omFrmRate29_97Hz) freqStr = "29.97Hz";
        else if (cmi->frameRate == omFrmRate24Hz) freqStr = "24.00Hz";
        else freqStr = "?????Hz";

        ptr += sprintf (ptr, "%s", freqStr);

        // add media types
        uint i;
        for (i = 0; i < NUM_CMI_MS; i++) {
            if (cmi->ms[i].type != omMediaUnknown)
                ptr += sprintf(ptr, ",%s",
                               mediaSummaryToString(&cmi->ms[i]));
            if (cmi->ms[i].type == omMediaMpegVideo) {
                ptr += sprintf(ptr, ",%4.1fMbs",
                               (double)cmi->ms[i].bitrate /
                               1000000.0);
            }
        }
        *ptr = 0;       // terminate the string
    }
    else {
        struct tm *t;
        t = localtime ((const time_t*)&cmi->creationTime);
        if (t) {
            uint year = t->tm_year;
            if (year >= 100)
                year -= 100;
            sprintf (ptr, "%02d/%02d/%02d %02d:%02d",
                     t->tm_mon + 1, t->tm_mday, year, t->tm_hour,
                     t->tm_min);
        }
        // else return emtpy string
    }
    if (pDisplayStr[0] != 0) {
        msg(pFormat, pClipName, cmi->protection ? 'P' : ' ',lengthStr, pDisplayStr);
    }
}    

LOCAL OmPlrError updateClipInfo (OmPlrHandle OmPlrHand, const char *name, ClipMapInfo *cmi)
{
    OmPlrError      error;
    OmPlrClipInfo   clipInfo;
    OmMediaSummary  ms[NUM_CMI_MS];

    // get new info
    clipInfo.maxMsTracks = NUM_CMI_MS;
    clipInfo.ms = ms;
    error = OmPlrClipGetInfo(OmPlrHand, name, &clipInfo);
    if (error)
        return error;

    // update the info
    cmi->firstFrame = clipInfo.firstFrame;
    cmi->lastFrame = clipInfo.lastFrame;
    cmi->defaultIn = clipInfo.defaultIn;
    cmi->defaultOut = clipInfo.defaultOut;
    cmi->numVideo = clipInfo.numVideo;
    cmi->numAudio = clipInfo.numAudio;
    cmi->frameRate = clipInfo.frameRate;
    cmi->protection = (clipInfo.protection != 0);
    cmi->openForWrite = (clipInfo.notOpenForWrite == 0);
    cmi->creationTime = clipInfo.creationTime;
    for (int i = 0; i < NUM_CMI_MS; i++)
        cmi->ms[i] = ms[i];     // note: copies garbage for structs with i >= maxMsTracks

    return omPlrOk;
}

