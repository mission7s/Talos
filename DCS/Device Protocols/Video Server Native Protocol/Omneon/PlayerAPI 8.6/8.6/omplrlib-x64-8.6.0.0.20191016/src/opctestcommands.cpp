/*********************************************************************

 Filename:    opcTestcommands.cpp

 Description: code for testing each function of the OPC api.

 Copyright (c) 1998-2001 Omneon Video Networks (TM)

 OMNEON VIDEO NETWORKS 

***********************************************************************/

/** include files **/
#include <time.h>   // for ctime function
#include <cstdlib>
#include <cstring>
#include "opctester.h"

/** local definitions **/
bool noop(FUNC_ARGS);

/* default settings */

/** external functions **/
// see opcTester.h

/** external data **/

/** public data **/
// none

/** private data **/

/** public functions **/
// most are 

/** private functions **/

/* Local function for creating a string to show time */
char *showTimeUser(OmTcData & rawTime, char * pTimeUser)
{
    uint hours, minutes, seconds, frames;          
    uint userBits;
    bool df, cf;

    if (pTimeUser == 0)
        return 0;

    if (!rawTime.GetTime(&hours, &minutes, &seconds, &frames, &df, &cf)) {
        strcpy (pTimeUser, "missing/invalid");
    } else {
        userBits = rawTime.Userbits();
        sprintf (pTimeUser, "%02u:%02u:%02u:%02u%s user=0x%08x",
            hours, minutes, seconds, frames, 
             df? "df" : "",
             userBits);
    }
    return pTimeUser;
}



//  "attach clipName {in out, in out index [-|0|+]} - attach a clip to timeline"},
bool attach(FUNC_ARGS)
{
    OmPlrError      error;
    int             clipIn;
    int             clipOut;
    OmPlrClipHandle hAttachBeforeClip = 0;      //default to attaching AFTER all other clips
    int             beforeClipIndex;
    OmPlrClipHandle newClipHandle;
    OmPlrShiftMode  shift = omPlrShiftModeAuto;         // default to omPlrShiftModeAuto mode

    if ((numWords < 2) || (numWords == 3)) {   // error if IN point and no OUT point
        return false;
    }

    // get arguments
    if (numWords == 2) {
        msg("   using default IN and OUT \n");
        clipIn = omPlrClipDefaultIn;
        clipOut = omPlrClipDefaultOut;
    } else {
        clipIn = strtol (word[2], 0, 0);
        if (clipIn < 0) clipIn = omPlrClipDefaultIn;

        clipOut = strtol (word[3], 0, 0);
        if (clipOut < 0) clipOut = omPlrClipDefaultOut;

        if (numWords > 4) {
            if (!mapClipIndexToHandle(word[4], &hAttachBeforeClip, &beforeClipIndex)) {
                    return(false);
            }
        }
     
        if (numWords > 5) {
            // 5th argument is SHIFT parameter -- "-" or "0" or "+"
            if (!mapArgToShift(word[5], &shift)) return(false);
        }
    }

    error = OmPlrAttach (gPlrHand, 
                         word[1], 
                         (uint)clipIn, 
                         (uint)clipOut, 
                         hAttachBeforeClip, 
                         shift, 
                         &newClipHandle);
    if (error) {
        errMsg("failed to attach clip %s  %s\n", word[1], showError(error));
    } else {
        if (hAttachBeforeClip != 0) {
            if (beforeClipIndex < 0) {
                msg(" successfully attached clip \"%s\" before clip %#08x;\n", 
                    word[1], 
                    hAttachBeforeClip);
            } else {
                msg(" successfully attached clip \"%s\" before clip at index %d;\n", 
                    word[1], 
                    beforeClipIndex);
            }
        } else {
            msg(" successfully attached clip \"%s\" at the end of the timeline;\n", 
                word[1]);
        }
        msg("\t  new handle is 0x%08X (shift was %s) \n", 
            newClipHandle, 
            printShift(shift));
    } 
    return true;
}

/*  LOCAL subroutine for clipCallbackAdd and clipCallbackWrite
    Get some information about the new clip
    Can't use gPlrHand since this is a separate thread -- to do so would risk a fault/crash 
    Need to open a new handle to avoid collison with existing
*/
void clipCallbackInfo(const char *clipName, const char *pDirectoryName, const char *pExtensionList)
{
    OmPlrError    error;
    OmPlrClipInfo clipInfo;
    OmPlrHandle newPlrHand = 0;

    error = OmPlrOpen(gDirName, 0 /* null pointer*/, &newPlrHand);
    if (error == 0)  {
        // Set clip directory if it is not the default
        if ((pDirectoryName != 0) && (pDirectoryName[0] != '\0'))
            error = OmPlrClipSetDirectory(newPlrHand, pDirectoryName);
        if (error == 0)  {
            if ((pExtensionList != 0) && (pExtensionList[0] != '\0'))
                error = OmPlrClipSetExtList(newPlrHand, pExtensionList);
            if (error == 0)  {

                    // Get the information about the clip
                clipInfo.maxMsTracks = 0;    // IMPORTANT to initialize this
                error = OmPlrClipGetInfo(newPlrHand, clipName, &clipInfo);
                if (error == 0) {
                    char *frameRate = "unknown";
                    if (clipInfo.frameRate == omFrmRate24Hz) frameRate = "24.0";
                    else if (clipInfo.frameRate == omFrmRate25Hz) frameRate = "25.0";
                    else if (clipInfo.frameRate == omFrmRate29_97Hz) frameRate = "29.97";
                    else if (clipInfo.frameRate == omFrmRate30Hz) frameRate = "30.0";

                    msg("Clip \"%s\", %s fps. Tracks: %d video, %d audio \n",
                        clipName, 
                        frameRate,
                        clipInfo.numVideo, 
                        clipInfo.numAudio);
                    msg("\t  Protected: %s     Open for write: %s\n",
                        (clipInfo.protection != 0)? "YES" : "no ",
                        (clipInfo.notOpenForWrite == 0)? "YES" : "no ");

                    msg("\t  ReadyToPlay: %s    res1: %s \n",
                        (clipInfo.notReadyToPlay == 0)? "YES " : "no" ,        // bit is activeLow logic
                        (clipInfo.res1 != 0)? "=1" : "=0 "  );

                    msg("\tFirst frame: %-8d    Last frame: %-8d\n",
                        clipInfo.firstFrame, 
                        clipInfo.lastFrame);
                    msg("\t Default in: %-8d   Default out: %-8d\n",
                        clipInfo.defaultIn, 
                        clipInfo.defaultOut); 
                }
            }
        }
    }
    if (error != 0)
        msg("Unable to get information about clip \"%s\"\n", clipName);

    if (newPlrHand != 0)  {
        OmPlrClose(newPlrHand);
    }
}

/*
 NOTE:  clipRegisterCallbacks uses a pointer to this function.
 This function (if registered) will then get called asynchronously whenever a clip is added to the file system.
 It will be called out of a SEPARATE THREAD.
*/
void clipCallbackAdd(const char *clipName, int param)
{
    msg("\nCallback called for ADDED clip \"%s\" (param=%#x)\n", clipName, param);

    // display information about the clip.
    // In your application the clipDirectory name could be the passed parameter
    // Having it global works here in this simplified example code since there is only one plrHandle.
    clipCallbackInfo(clipName, gClipDirectoryName, gClipExtensionList);
}    


/*
 NOTE:  clipRegisterCallbacks uses a pointer to this function.
 This function (if registered) will then get called asynchronously whenever a clip is deleted from the file system.
 It will be called out of a SEPARATE THREAD.
*/
void clipCallbackDel(const char *clipName, int param)
{
    msg("\nCallback called for DELETED clip \"%s\" (param=%#x)\n", clipName, param);
}    

/*
 NOTE:  clipRegisterCallbacks uses a pointer to this function.
 This function (if registered) will then get called asynchronously whenever a clip is added to the file system.
 It will be called out of a SEPARATE THREAD.
*/
void clipWriteCallbackOpen(const char *clipName, int param)
{
    msg("\nCallback called for WRITE OPEN on clip \"%s\" (param=%#x)\n", clipName, param);
    // display information about the clip.
    // In your application the clipDirectory name could be the passed parameter
    // Having it global works here in this simplified example code since there is only one plrHandle.
    clipCallbackInfo(clipName, gClipDirectoryName, gClipExtensionList);

}    


/*
 NOTE:  clipRegisterCallbacks uses a pointer to this function.
 This function (if registered) will then get called asynchronously whenever a clip is deleted from the file system.
 It will be called out of a SEPARATE THREAD.
*/
void clipWriteCallbackClose(const char *clipName, int param)
{
    msg("\nCallback called for WRITE CLOSE on clip \"%s\" (param=%#x)\n", clipName, param);
    // display information about the clip.
    // In your application the clipDirectory name could be the passed parameter
    // Having it global works here in this simplified example code since there is only one plrHandle.
    clipCallbackInfo(clipName, gClipDirectoryName, gClipExtensionList);
}    

/*
 NOTE:  OmPlrOpen1 uses a pointer to this function.
 This function (if registered) will then get called asynchronously whenever 
 a connection to the player gets made.
 It will be called out of a SEPARATE THREAD.
*/
void connectCallback(OmPlrHandle plrHandle)
{
    msg("\n*** Callback called for connection to player with handle %#x. ***\n", 
        plrHandle);
}    


// clipCopy clipName copyName first length [offset] - copy a clip from first, for length, with optional offset of first in the copy.
bool clipCopy(FUNC_ARGS)
{
    OmPlrError   error;
    char *clipName;
    char *copyName;
    int firstFrame;
    int length;
    int offset;

    // If the operator used the command clipCopyX, then allow multiple concurrent copies
    bool useGlobal = (stricmp(word[0], "clipCopyX") == 0)? false : true;

    if (numWords < 6) return false;

    if (useGlobal & (gCopyHand != 0)) {
        errMsg("Can't copy; global copy handle already in use.\n" 
                "This test program allows only one copy at a time.\n"
                "If you have a copy running, stop it (clipCopyAbort).\n"
                "Free the copy handle (clipCopyFree), \n"
                "and then retry this copy.\n");
        return true;
    }

    clipName = word[1];
    copyName = word[2];
    firstFrame = strtoul(word[3], 0, 0);
    length = strtoul(word[4], 0, 0);
    offset = strtoul(word[5], 0, 0);

    if (firstFrame < 0)  {
        firstFrame = ~0;        // special value -- matches first recorded frame
    }
    if (length < 0)  {
        length = ~0;            // special value -- meaning full duration
    }
    if (offset < 0)  {
        offset = ~0;            // special value -- match destination to source firstFrame.
    }

    error = OmPlrClipCopy(gPlrHand, 
                          clipName, 
                          copyName,
                          firstFrame,
                          length,
                          offset,
                          false,  // bMetadata -- obsolete variable
                          &gCopyHand);

    if (error) {
        errMsg("Failed to copy clip %s: %s\n", clipName, showError(error));
    }
    else msg("Copying %s to %s; clipCopy Handle is 0x%08X; use clipCopyStatus to monitor progress.\n",
              clipName,
              copyName,
              gCopyHand);
 
    return true;
}

// clipCopyAbort - aborts current clip copy operation
bool clipCopyAbort(FUNC_ARGS)
{
    OmPlrError   error;
    OmPlrClipCopyHandle tempH;

    if (numWords > 2) return false;

    if (numWords == 2)  {
        tempH = (OmPlrClipCopyHandle) strtoul(word[1], 0, 0);
    } else if (gCopyHand != 0) {
        tempH = gCopyHand;
    } else  {
        errMsg("Can't abort copy; no copy operation in progress.\n");
        return true;
    }

    error = OmPlrClipCopyAbort(gPlrHand, tempH);
    if (error) {
        errMsg("Failed to abort copy: %s\n", showError(error));
    }
    else msg("Clip copy aborted. Use clipCopyFree to free up the copy handle.\n");
 
    return true;
}

// clipCopyEnumerate - enumerate copies in progress (handles that are assigned)
bool clipCopyEnumerate(FUNC_ARGS)
{
    OmPlrError          error;
    OmPlrClipCopyHandle handles[COPY_HANDLES];
    uint                handlesUsed;

    if (numWords > 1) return false;

    error = OmPlrClipCopyEnumerate(gPlrHand,
                                   handles,
                                   COPY_HANDLES,
                                   &handlesUsed);
    if (error) {
        errMsg("Failed to enumerate copies: %s\n", showError(error));
    }
    else {
        msg("There are %u copy handle(s) currently in use for this player.\n",
            handlesUsed);
        for (unsigned int i=0; i < handlesUsed; i++)  {
            msg ("\t handle %u is 0x%08X\n", i+1, handles[i]);
        }
        
        // sanity check on the local opcTester logic
        if (handlesUsed == 0) {
            gCopyHand = 0;  
        };

    }
 
    return true;
}

// clipCopyFree - free the copy handle created when copying started
//  Clear specified handle or optionally clear the global handle kept by this program.
bool clipCopyFree(FUNC_ARGS)
{
    OmPlrError error;
    OmPlrClipCopyHandle tempH;
    bool clearGlobal = false;

    if (numWords > 2) return false;

    if (numWords == 2)  {
        tempH = (OmPlrClipCopyHandle) strtoul(word[1], 0, 0);
        if (tempH == gCopyHand)
            clearGlobal = true;
    } else if (gCopyHand != 0) {
        tempH = gCopyHand;
        clearGlobal = true;
    } else  {
        errMsg("Can't free global copy handle as it is not currently allocated.\n");
        return true;
    }

    error = OmPlrClipCopyFree(gPlrHand, tempH);
    if (error) {
        errMsg("Failed to free clip copy handle: %s\n", showError(error));
    } 
    
    if (clearGlobal)  {
        // even if there was an error!
        gCopyHand = 0;
    }
 
    return true;
}

// clipCopyStatus - report status of copy operation
bool clipCopyStatus(FUNC_ARGS)
{
    OmPlrError          error;
    uint                numFramesCopied;
    uint                copyLength;
    OmPlrError          doneStatus;
    bool                bDone;
    OmPlrClipCopyHandle tempH;

    if (numWords > 2) return false;

    if (numWords == 2)  {
        tempH = (OmPlrClipCopyHandle) strtoul(word[1], 0, 0);
    } else if (gCopyHand != 0) {
        tempH = gCopyHand;
    } else  {
        errMsg("Can't get clip copy status; no copy operation in progress.\n");
        return true;
    }

    error = OmPlrClipCopyGetStatus(gPlrHand, 
                                   tempH,
                                   &numFramesCopied,
                                   &copyLength,
                                   &bDone,
                                   &doneStatus);

    if (error) {
        errMsg("Failed to get clip copy status: %s\n", showError(error));
    }
    else if (bDone)  {
        msg("Copy Complete; status = \"%s\" for handle 0x%08X;\n" " copied %u frames out of %u frames.\n", 
            showError(doneStatus), tempH, numFramesCopied, copyLength);
    }else {
        msg("Copying %u frames total, %u frames already copied. (handle 0x%08X) \n", 
            copyLength, numFramesCopied, tempH);
    }
 
    return true;
}


// clipCopyGetParms - report arguements of a copy operation
bool clipCopyGetParams(FUNC_ARGS)
{
    OmPlrError          error;
    uint                first;
    uint                length;
    uint                startFrame;
    char                srcName[omPlrMaxClipDirLen];
    char                destName[omPlrMaxClipDirLen];
    bool                bMetadata;
    OmPlrClipCopyHandle tempH;

    if (numWords > 2) return false;

    if (numWords == 2)  {
        tempH = (OmPlrClipCopyHandle) strtoul(word[1], 0, 0);
    } else if (gCopyHand != 0) {
        tempH = gCopyHand;
    } else  {
        errMsg("Can't get clip copy status; no copy operation in progress.\n");
        return true;
    }

    error = OmPlrClipCopyGetParams(gPlrHand, 
                                   tempH,
                                   srcName,
                                   omPlrMaxClipDirLen-1,
                                   destName,
                                   omPlrMaxClipDirLen-1,
                                   &first,
                                   &length,
                                   &startFrame,
                                   &bMetadata);

    if (error) {
        errMsg("Failed to get clip copy parameters: %s\n", showError(error));
    }else {
        // Use "%d" instead of "%u" -- so a "~0" arg shows as -1 instead of 423456777234
        msg("Copying clip \"%s\" to clip \"%s\"\n", srcName, destName);
        msg("  (Starting at frame %d, length %d, dest frame %d)\n",
            first,  length,  startFrame);
    }
 
    return true;
}

bool clipDelete(FUNC_ARGS)
{
    OmPlrError error;

    if (numWords < 2) return false;

    error = OmPlrClipDelete (gPlrHand, word[1]);
    if (error == omPlrInvalidClip) {
        errMsg("%s is not a valid clip\n", word[1]);
    } else if (error) {
        errMsg("failed to delete clip %s   %s\n", word[1], showError(error));
        return true;
    }
    else msg("deleted clip %s\n", word[1]);

    return true;
}


bool clipExist(FUNC_ARGS)
{
    OmPlrError error;
    char       *name;
    bool       exists;

    if (numWords < 2) return false;

    name = word[1];
    error = OmPlrClipExists (gPlrHand, name, &exists);
    if (error) {
        errMsg("failed to check clip existence %s   %s\n", 
               name, 
               showError(error));
        return true;
    }

    msg("clip %s %s\n", name, exists ? "exists" : "does not exist");
    return true;
}

/*
Used in conjunction with ClipGetNext.
Return name of 1st clip.
Sized to only accept one name

Doesn't require any arguments from the operator
Will work ok with a NULL player
*/
bool clipGetFirst(FUNC_ARGS)
{
    OmPlrError error;
    char       clipName[omPlrMaxClipNameLen];
  
    error = OmPlrClipGetFirst (gPlrHand, clipName, omPlrMaxClipNameLen);
    if (error == omPlrEndOfList) {
        msg("No clips exist in current directory\n");
        return true;
    }
    if (error) {
        errMsg("failed to get name of first clip: %s\n", showError(error));
        return true;
    }
    // else
    msg("Name of 1st clip  is \"%s\"\n", clipName);
    return true;
}    


/*
Show the names (and paths) of media files for a clip
*/
bool clipGetMediaName(FUNC_ARGS)       
{
#define MaxTracks 32
    OmPlrError    error;

    if (numWords < 2) return false;

    char mediaName[omPlrMaxClipDirLen];
    uint trackIndex;   // index across the media tracks
    uint fileIndex;    // file selection, a track may have many files

    msg("  Trk#   File#               media path/file \n");

     // Outer loop over all tracks for this clip
    //  (start with "track 0"  -- which is the .mov file
    for (trackIndex = 0, error = (OmPlrError)0; (error == 0) && (trackIndex < MaxTracks); trackIndex++) {
        // Inner loop over all files for this track
        for ( fileIndex = 0;  error == 0; fileIndex++){
            error = OmPlrClipGetMediaName(gPlrHand, word[1], 
                                           trackIndex, fileIndex,
                                           mediaName, sizeof(mediaName));
            if (!error) {
                msg("   %d      %d     %s\n", trackIndex, fileIndex+1, mediaName);
            }
        }
        // Normal exit from inner loop is with omPlrEndOfList
        if ((error == omPlrEndOfList) && (fileIndex > 1)) {
            error = (OmPlrError)0;   // if saw at least one file on this track
        }
        if ((error != 0) && (error != omPlrEndOfList))  {
            errMsg("failure while getting media file names for clip %s on track %d   %s\n", 
                   word[1], trackIndex+1,
                   showError(error));
        }
    }
    return(true);
}


bool clipGetNext(FUNC_ARGS)
{
    OmPlrError error;
    char       clipName[omPlrMaxClipNameLen];

    error = OmPlrClipGetNext (gPlrHand, clipName, omPlrMaxClipNameLen);
    if (error == omPlrEndOfList) {
        msg("No other clips exist in current directory\n");
        return true;
    }
    if (error) {
        errMsg("failed to get name of next clip: %s\n", showError(error));
        return true;
    }
    // else
    msg("Name of next clip  is \"%s\"\n", clipName);
    return true;
}    

bool clipGetInfo(FUNC_ARGS) 
{
    OmPlrError    error;
    OmPlrClipInfo clipInfo;
    
    if (numWords < 2) return false;

    clipInfo.maxMsTracks = 0;    // IMPORTANT to initialize this
    error = OmPlrClipGetInfo(gPlrHand, word[1], &clipInfo);
    if (error != 0) {
        errMsg("failed to get information for clip %s   %s\n", 
               word[1],
               showError(error));
    } else {
        time_t creationTime = clipInfo.creationTime;
        char *timeStr = ctime((time_t *)&creationTime);
        if (!timeStr) timeStr = "[unknown]\n";

        char *frameRate = "unknown";
        if (clipInfo.frameRate == omFrmRate24Hz) frameRate = "24.0";
        else if (clipInfo.frameRate == omFrmRate25Hz) frameRate = "25.0";
        else if (clipInfo.frameRate == omFrmRate29_97Hz) frameRate = "29.97";
        else if (clipInfo.frameRate == omFrmRate30Hz) frameRate = "30.0";

        msg("Clip \"%s\", %s fps. Tracks: %d video, %d audio \n",
            word[1], 
            frameRate,
            clipInfo.numVideo, 
            clipInfo.numAudio);
        msg("\t    Created: %s", timeStr);
        msg("\t  Protected: %s     Open for write: %s\n",
            (clipInfo.protection != 0)? "YES" : "no ",
            (clipInfo.notOpenForWrite == 0)? "YES" : "no ");

        msg("\t  ReadyToPlay: %s    res1: %s \n",
            (clipInfo.notReadyToPlay == 0)? "YES " : "no" ,        // bit is activeLow logic
            (clipInfo.res1 != 0)? "=1" : "=0 "  );

        msg("\tFirst frame: %-8d    Last frame: %-8d\n",
            clipInfo.firstFrame, 
            clipInfo.lastFrame);
        msg("\t Default in: %-8d   Default out: %-8d\n",
            clipInfo.defaultIn, 
            clipInfo.defaultOut); 
    }
    return(true);
}    


// clipGetUserData clipName Key - get user data for key stored in clipName
bool clipGetUserData(FUNC_ARGS)
{
    OmPlrError error;
    uint       dataSize = 0;
    char       data[USER_DATA_SIZE];

    if (numWords != 3 ) return false;

    memset(data, 0, USER_DATA_SIZE);    // pre-clear data, just in case

    error = OmPlrClipGetUserData(gPlrHand,
                                 word[1],
                                 word[2],
                                 (unsigned char *)data,
                                 USER_DATA_SIZE-1,  // leave last null, just in case
                                 &dataSize);
    if (error != 0) {
        errMsg("failed to get user data for clip %s: %s\n", 
               word[1],
               showError(error));
    } else {
        msg("Clip \"%s\" has %d byte%s of data for key \"%s\":\n",
            word[1],
            dataSize,
            (dataSize == 1 ? "" : "s"),
            word[2]);
        msg("[%s]\n", data);
    }
    return(true);
}


// clipGetUserDataAndKey clipName Index - get user data for key stored in clipName
bool clipGetUserDataAndKey(FUNC_ARGS)
{
    OmPlrError error;
    uint       dataSize = 0;
    uint       keyIndex;
    char       key[omPlrMaxUserDataKeyLen];
    char       data[USER_DATA_SIZE];

    if (numWords < 3 ) return false;

    memset(key, 0, omPlrMaxUserDataKeyLen);    // pre-clear data, just in case
    memset(data, 0, USER_DATA_SIZE);    // pre-clear data, just in case
    keyIndex = strtol (word[2], 0, 0);

#if 1

    int keyBufSizeParm = numWords < 4? omPlrMaxUserDataKeyLen-1 : strtol (word[3], 0, 0);
    int dataBufSizeParm = numWords < 5? USER_DATA_SIZE-1 : strtol (word[4], 0, 0);
    error = OmPlrClipGetUserDataAndKey(gPlrHand,
                                 word[1],  // clipname
                                 keyIndex,
                                 key,  // key name
                                 keyBufSizeParm, 
                                 (unsigned char *)data,
                                 dataBufSizeParm,  // leave last null, just in case
                                 &dataSize);
#else
    error = OmPlrClipGetUserDataAndKey(gPlrHand,
                                 word[1],  // clipname
                                 keyIndex,
                                 key,  // key name
                                 omPlrMaxUserDataKeyLen-1, 
                                 (unsigned char *)data,
                                 USER_DATA_SIZE-1,  // leave last null, just in case
                                 &dataSize);
#endif
    if (error != 0) {
        errMsg("failed to get user data for clip %s: %s\n", 
               word[1],
               showError(error));
    } else {
        msg("Clip \"%s\" has %d byte%s of data at index %d for key \"%s\":\n",
            word[1],
            dataSize,
            (dataSize == 1 ? "" : "s"),
            keyIndex,
            key);
        msg("[%s]\n", data);
    }
    return(true);
}


// clipGetTrackUserData clipName trackNum Key - get user data for key stored in clipName
bool clipGetTrackUserData(FUNC_ARGS)
{
    OmPlrError error;
    uint       dataSize = 0;
    uint       trackNum;
    char       data[USER_DATA_SIZE];

    if (numWords != 4 ) return false;

    trackNum = strtol (word[2], 0, 0);
    memset(data, 0, USER_DATA_SIZE);    // pre-clear data, just in case

    error = OmPlrClipGetTrackUserData(gPlrHand,
                                 word[1],  // clipname
                                 trackNum, 
                                 word[3],   // key
                                 (unsigned char *)data,
                                 USER_DATA_SIZE-1,  // leave last null, just in case
                                 &dataSize);
    if (error != 0) {
        errMsg("failed to get user data for track %d on clip %s: %s\n", 
               trackNum, word[1],
               showError(error));
    } else {
        msg("Track %d on clip \"%s\" has %d byte%s of data for key \"%s\":\n",
            trackNum, word[1],
            dataSize,
            (dataSize == 1 ? "" : "s"),
            word[3]);
        msg("[%s]\n", data);
    }
    return(true);
}


// clipGetTrackUserDataAndKey clipName track Index - get user data for key stored in clipName
bool clipGetTrackUserDataAndKey(FUNC_ARGS)
{
    OmPlrError error;
    uint       dataSize = 0;
    uint       keyIndex;
    uint       trackNum;
    char       key[omPlrMaxUserDataKeyLen];
    char       data[USER_DATA_SIZE];

    if (numWords < 4 ) return false;

    memset(key, 0, omPlrMaxUserDataKeyLen);    // pre-clear data, just in case
    memset(data, 0, USER_DATA_SIZE);    // pre-clear data, just in case
    trackNum = strtol (word[2], 0, 0);
    keyIndex = strtol (word[3], 0, 0);

#if 1

    int keyBufSizeParm = numWords < 5? omPlrMaxUserDataKeyLen-1 : strtol (word[4], 0, 0);
    int dataBufSizeParm = numWords < 6? USER_DATA_SIZE-1 : strtol (word[5], 0, 0);
    error = OmPlrClipGetTrackUserDataAndKey(gPlrHand,
                                 word[1],  // clipname
                                 trackNum,
                                 keyIndex,
                                 key,  // key name
                                 keyBufSizeParm, 
                                 (unsigned char *)data,
                                 dataBufSizeParm,  // leave last null, just in case
                                 &dataSize);
#else
    error = OmPlrClipGetTrackUserDataAndKey(gPlrHand,
                                 word[1],  // clipname
                                 trackNum,
                                 keyIndex,
                                 key,  // key name
                                 omPlrMaxUserDataKeyLen-1, 
                                 (unsigned char *)data,
                                 USER_DATA_SIZE-1,  // leave last null, just in case
                                 &dataSize);
#endif
    if (error != 0) {
        errMsg("failed to get user data for track %d on clip %s: %s\n", 
               trackNum, word[1],
               showError(error));
    } else {
        msg("Track %d on clip \"%s\" has %d byte%s of data at index %d for key \"%s\":\n",
            trackNum, word[1],
            dataSize,
            (dataSize == 1 ? "" : "s"),
            keyIndex,
            key);
        msg("[%s]\n", data);
    }
    return(true);
}


bool clipProtect(FUNC_ARGS)
{
    OmPlrError error;
    char       *ptr;
    bool       protect;

    if (numWords < 3) return false; // xx clip  on/off

    // argument can be either "-on" or "on" or "-off" or "off"
    ptr = word[2];
    if (*ptr == '-') ptr++;     // skip over any leading "-"

    if (stricmp (ptr, "on") == 0) protect = true;
    else if (stricmp (ptr, "off") == 0) protect = false;
    else return false;

    error = OmPlrClipSetProtection (gPlrHand, word[1], protect);
    if (!error) msg("protection %s for clip %s\n", 
                    protect ? "set":"removed",
                    word[1]);
    else errMsg("failed to set protection for clip %s   %s\n", 
                word[1],
                showError(error));
    
    return true;
}

#define ADDEDPARM  0x11223344
#define DELETEDPARM 0xAABBCCDD

bool clipRegisterCallbacks(FUNC_ARGS)
{
    OmPlrError error;

    char charAdd = ' ';  // - for off, + for on
    char charDel = ' ';  // - for off, + for on

    // Parse out "+/-New" and "+/-Old"
    if (numWords < 3) return false;

    if (strnicmp(&word[1][1], "add", 3) == 0) {
        charAdd = word[1][0];
    } else if (strnicmp(&word[2][1], "add", 3) == 0) {
        charAdd = word[2][0];
    }

    if (strnicmp(&word[1][1], "del", 4) == 0) {
        charDel = word[1][0];
    } else if (strnicmp(&word[2][1], "del", 3) == 0) {
        charDel = word[2][0];
    }

    if ((charAdd != '-') && (charAdd != '+')) charAdd = ' ';
    if ((charDel != '-') && (charDel != '+')) charDel = ' ';

    // abort and give usage message if don't have the right old/new info
    if ((charAdd == ' ') || (charDel == ' ')) return(false);
        
    error = OmPlrClipRegisterCallbacks(gPlrHand, 
                                       (charAdd == '+')? clipCallbackAdd : 0,
                                       ADDEDPARM,
                                       (charDel == '+')? clipCallbackDel : 0,
                                       DELETEDPARM);
    if (error == 0) {
        msg("successfully (un)registered clip callbacks (Add=%c; Del=%c)\n", 
            charAdd, 
            charDel);
    }
    else errMsg("failed to register callbacks  %s\n", showError(error));

    return true;
}    

#define OPENPARM  0x55667788
#define CLOSEPARM 0xFFEEDDCC

bool clipRegisterWriteCallbacks(FUNC_ARGS)
{
    OmPlrError error;

    char charAdd = ' ';  // - for off, + for on
    char charDel = ' ';  // - for off, + for on

    // Parse out "+/-open" and "+/-close"
    if (numWords < 3) return false;

    if (strnicmp(&word[1][1], "open", 2) == 0) {
        charAdd = word[1][0];
    } else if (strnicmp(&word[2][1], "open", 2) == 0) {
        charAdd = word[2][0];
    }

    if (strnicmp(&word[1][1], "close", 2) == 0) {
        charDel = word[1][0];
    } else if (strnicmp(&word[2][1], "close", 2) == 0) {
        charDel = word[2][0];
    }

    if ((charAdd != '-') && (charAdd != '+')) charAdd = ' ';
    if ((charDel != '-') && (charDel != '+')) charDel = ' ';

    // abort and give usage message if don't have the right old/new info
    if ((charAdd == ' ') || (charDel == ' ')) return(false);
        
    error = OmPlrClipRegisterWriteCallbacks(gPlrHand, 
                                       (charAdd == '+')? clipWriteCallbackOpen : 0,
                                       OPENPARM,
                                       (charDel == '+')? clipWriteCallbackClose : 0,
                                       CLOSEPARM);
    if (error == 0) {
        msg("successfully (un)registered clip write callbacks (Open=%c; Close=%c)\n", 
            charAdd, 
            charDel);
    }
    else errMsg("failed to register clip write callbacks  %s\n", showError(error));

    return true;
}    

bool clipRename(FUNC_ARGS)
{
    OmPlrError error;

    if (numWords < 3) return false;

    error = OmPlrClipRename (gPlrHand, word[1], word[2]);
    if (error == 0) msg("clip %s renamed to %s\n", word[1], word[2]);
    else errMsg("failed to rename clip %s   %s\n", word[1], showError(error));
    return true;
}


bool clipSetDefaultInOut(FUNC_ARGS)
{
    OmPlrError error;
    uint     newDefIn;
    uint     newDefOut;

    if (numWords < 4) return false;

    newDefIn = strtol (word[2], 0, 0);
    newDefOut = strtol (word[3], 0, 0);
    error = OmPlrClipSetDefaultInOut (gPlrHand, word[1], newDefIn, newDefOut);

    if (error) errMsg("failed to set clip default in/out point for %s  %s\n",
                      word[1], 
                      showError(error));
    else msg("New default in/out values set for clip %s\n", word[1]);

    return true;
}

// clipSetUserData clipName key [data] - save user data with key for clipName
// If no data, clear data; data can be quoted to include spaces.
bool clipSetUserData(FUNC_ARGS)
{
    OmPlrError    error;
    uint          dataSize = 0;
    unsigned char *pData = NULL;

    if (numWords < 3 || numWords > 4) return false;

    if (numWords == 4) {
        pData = (unsigned char *)word[3];
        dataSize = strlen((const char *)pData);
    }
    else {
        pData = (unsigned char *)""; // pData cannot be NULL ever.
        dataSize = 0;
    }

    error = OmPlrClipSetUserData(gPlrHand,
                                 word[1],
                                 word[2],
                                 pData,
                                 dataSize);
    if (error != 0) {
        errMsg("failed to set user data for clip %s: %s\n", 
               word[1],
               showError(error));
    } else {
        msg("Clip \"%s\" now has %d byte%s of data for key \"%s\".\n",
            word[1],
            dataSize,
            (dataSize == 1 ? "" : "s"),
            word[2]);
    }
    return(true);
}

// clipSetTrackUserData clipName trackNum key [data] - save user data with key for clipName
// If no data, clear data; data can be quoted to include spaces.
bool clipSetTrackUserData(FUNC_ARGS)
{
    OmPlrError    error;
    uint       trackNum;
    uint          dataSize = 0;
    unsigned char *pData = NULL;

    if (numWords < 4 || numWords > 5) return false;

    if (numWords == 5) {
        pData = (unsigned char *)word[4];
        dataSize = strlen((const char *)pData);
    }
    else {
        pData = (unsigned char *)""; // pData cannot be NULL ever.
        dataSize = 0;
    }
    trackNum = strtol (word[2], 0, 0);

    error = OmPlrClipSetTrackUserData(gPlrHand,
                                 word[1],  // clip
                                 trackNum, 
                                 word[3],  // key
                                 pData,
                                 dataSize);
    if (error != 0) {
        errMsg("failed to set user data for track %d on clip %s: %s\n", 
               trackNum, word[1],
               showError(error));
    } else {
        msg("Track %d on clip \"%s\" now has %d byte%s of data for key \"%s\".\n",
            trackNum, word[1],
            dataSize,
            (dataSize == 1 ? "" : "s"),
            word[3]);
    }
    return(true);
}

bool close(FUNC_ARGS)
{
    OmPlrError error;

    if (numWords > 1) {
        // close using given handle 
        // (allows you to see what happens if close twice)
        OmPlrHandle playerHandle = (OmPlrHandle)strtol(word[1], 0, 0);

        error = OmPlrClose(playerHandle);
        if (error) errMsg("failed to close connection %#08x:  %s\n", 
                           playerHandle, 
                           showError(error));
        else  {
            msg("closed connection %#08x\n", playerHandle);
            if (playerHandle == gPlrHand)  {
                gPlrHand = 0;
                gPlrName[0] = '\0';  // close out the little bit of history held by opcTester.
            }
            
        }
    } else {
        error = OmPlrClose(gPlrHand);
        if (error) errMsg("player %s failed to enter play cue state   %s\n",
                          gPlrName, 
                          showError(error));
        gPlrHand = 0;
        gPlrName[0] = '\0';  // we have lost/abandoned the connection!!!
        msg("disconnected from director %s\n", gDirName);
    }

    return true;
}



bool cuePlay(FUNC_ARGS)
{
    double     rate;
    OmPlrError error;

    if (numWords > 1) sscanf (word[1], "%lf", &rate);
    else rate = 1.0;
    
    error = OmPlrCuePlay (gPlrHand, rate);

    if (error) errMsg("player %s failed to enter play cue state   %s\n",
                      gPlrName, 
                      showError(error));
    else msg("player %s cued for play\n", gPlrName);
   
    return true;
}



bool cueRecord(FUNC_ARGS)
{
    OmPlrError error;

    error = OmPlrCueRecord (gPlrHand);
    if (error) errMsg("player %s failed to enter record state   %s\n",
                      gPlrName, 
                      showError(error));
    else msg("player %s cued for record\n", gPlrName);

    return true;
}


bool detachAll(FUNC_ARGS)
{
    OmPlrError error;

    error = OmPlrDetachAllClips (gPlrHand);
    if (error) {
        errMsg("failed to detach all clips on player %s: %s\n",
               gPlrName, 
               showError(error));
        return true;
    }
    msg("detached all clips on player %s\n", gPlrName);
    return true;
}    

bool detachOne(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle plrClipHandle;
    int             clipIndex;
    OmPlrShiftMode  shift = omPlrShiftModeAuto;

    if (numWords < 2) return false;

    if (!mapClipIndexToHandle(word[1], &plrClipHandle, &clipIndex)) {
        return(false);
    }

    if (numWords > 2) {
        // 2nd argument is SHIFT parameter -- "-" or "0" or "+"
        if (!mapArgToShift(word[2], &shift)) return(false);
    }

    // detach clip
    error = OmPlrDetach (gPlrHand, plrClipHandle, shift);
    if (error) {
        errMsg("failed to detach clip %d (handle %#08x) on player %s  %s\n", 
               clipIndex, 
               plrClipHandle,
               gPlrName, 
               showError(error));
    } else {
        msg("player %s ejected clip at index %d (handle %#08x)(%s)\n", 
            gPlrName, 
            clipIndex, 
            plrClipHandle,
            printShift(shift));
    }

    return true;
}


bool getApp(FUNC_ARGS)
{
    OmPlrError error;
    OmPlrApp   playerApp;

    error = OmPlrGetApp(gPlrHand, &playerApp);
    if (error) {
        errMsg("failed to get app for this player: %s\n", showError(error));
        return true;
    }
    // else
    msg("Application of this player is \"%s\"\n", printApp(playerApp));
    return true;
}    

bool getAppClipDir(FUNC_ARGS)
{
    OmPlrError error;
    char  appClipDir[omPlrMaxClipDirLen];

    error = OmPlrGetAppClipDirectory(gPlrHand, appClipDir, omPlrMaxClipDirLen-1);
    if (error) {
        errMsg("failed to get \"application\" clip directory for this player: %s\n", showError(error));
        return true;
    }
    // else
    msg("Suggested clip directory for this player is \"%s\"\n", appClipDir);
    return true;
}    


bool getClipAtNum(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle clipHandle;
    int           clipNumber;

    if (numWords < 2) return false;

    clipNumber = strtol (word[1], 0, 0);
    error = OmPlrGetClipAtNum(gPlrHand, clipNumber, &clipHandle);
    if (error) {
        errMsg("unable to get clip at number:   %s\n", showError(error));
        return true;
    }
    msg("The clip at index %d on the timeline has handle %#08x \n", 
        clipNumber, 
        clipHandle);
    return true;
}    

bool getClipAtPos(FUNC_ARGS)
{
    OmPlrError      error;
    int           tlinePosition;
    OmPlrClipHandle clipHandle;
    int           clipAttachPoint;

    if (numWords < 2) return false;

    tlinePosition = strtol (word[1], 0, 0);
    error = OmPlrGetClipAtPos(gPlrHand, tlinePosition, &clipHandle, &clipAttachPoint);
    if (error) {
        errMsg("unable to get clip at position:   %s\n", showError(error));
        return true;
    }
    msg("Clip at timeline position %d has handle %#08x and starts at timeline position %d\n", 
        tlinePosition, 
        clipHandle, 
        clipAttachPoint);
    return true;
}    


bool getClipName(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle clipHandle;
    int           clipIndex;
    char            clipName[omPlrMaxClipNameLen];

    if (numWords < 2) return false;

    if (!mapClipIndexToHandle(word[1], &clipHandle, &clipIndex)) { 
        return(false);
    }

    error = OmPlrGetClipName(gPlrHand, clipHandle, clipName, omPlrMaxClipNameLen);
    if (error) {
        errMsg("unable to get name for clip: %s\n", showError(error));
        return true;
    }
    if (clipIndex < 0)  {
        msg("Clip with handle %#08x on timeline is named \"%s\"\n", 
            clipHandle, 
            clipName);
    } else {
        msg("Clip at index %d (handle %#08x) on timeline is named \"%s\"\n", 
            clipIndex, 
            clipHandle, 
            clipName);
    }
    return true;
}    

bool getClipPath(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle clipHandle;
    int           clipIndex;
    char            clipPath[omPlrMaxClipDirLen];
 
    if (numWords < 2) return false;

    if (!mapClipIndexToHandle(word[1], &clipHandle, &clipIndex)) {
        return(false);
    }

    error = OmPlrGetClipPath(gPlrHand, clipHandle, clipPath, omPlrMaxClipDirLen);
    if (error) {
        errMsg("unable to get name for clip:   %s\n", showError(error));
        return true;
    }
    if (clipIndex < 0)  {
        msg("Clip with handle %#08x on timeline was loaded from directory \"%s\"\n", 
            clipHandle, 
            clipPath);
    } else {
        msg("Clip at index %d (handle %#08x) on timeline was loaded from directory \"%s\"\n", 
            clipIndex, 
            clipHandle, 
            clipPath);
    }
    return true;
}

bool getDropFrame(FUNC_ARGS)
{
    OmPlrError error;
    bool       dropFrame;

    error = OmPlrGetDropFrame(gPlrHand, &dropFrame);
    if (error)
        errMsg("failed to get drop frame setting  %s\n", showError(error));
    else
        msg("drop frame %s\n", dropFrame ? "enabled" : "disabled");
    return true;
}

/*
Look up the error -- accept error number as either hex or decimal.
IF input as decimal, then it is ASSUMED that it is relative to the PLAYER_ERROR_BASE
*/
bool getErrorString(FUNC_ARGS)
{
    OmPlrError lookupError;

    if (numWords < 2) return false;

    lookupError = (OmPlrError)strtol (word[1], 0, 0);
    if ((word[1][1] != 'X') && (word[1][1] != 'x')) {
        lookupError = (OmPlrError)(PLAYER_ERROR_BASE + lookupError);
    }
    errMsg("error code %#04x (%d) is \"%s\"\n",
           lookupError, 
           lookupError - PLAYER_ERROR_BASE, 
           OmPlrGetErrorString (lookupError));
    return(true);
}    

bool getFirstPlayer(FUNC_ARGS)
{
    OmPlrError error;
    char       playerName[omPlrMaxPlayerNameLen];

    error = OmPlrGetFirstPlayer(gPlrHand, playerName, omPlrMaxPlayerNameLen);
    if (error == omPlrEndOfList)  {
        msg("No players exist\n");
        return true;
    }
    if (error) {
        errMsg("failed to get name of first player: %s\n", showError(error));
        return true;
    }
    // else
    msg("Name of 1st player  is \"%s\"\n", playerName);
    return true;
}    

bool getNextPlayer(FUNC_ARGS)
{
    OmPlrError error;
    char       playerName[omPlrMaxPlayerNameLen];

    error = OmPlrGetNextPlayer(gPlrHand, playerName, omPlrMaxPlayerNameLen);
    if (error == omPlrEndOfList)  {
        msg("No more players exist\n");
        return true;
    }
    if (error) {
        errMsg("failed to get name of next player: %s\n", showError(error));
        return true;
    }
    // else
    msg("Name of next player  is \"%s\"\n", playerName);
    return true;
}    


bool getFrameRate(FUNC_ARGS)
{
    OmPlrError  error;
    OmFrameRate frameRate;
    double      rate;

    error = OmPlrGetFrameRate (gPlrHand, &frameRate);
    if (error) {
        errMsg("failed to get frame rate for player %s  %s\n",
                gPlrName, 
                showError(error));
        return true;
    }
    if (frameRate == omFrmRate24Hz) rate = 24.0;
    else if (frameRate == omFrmRate25Hz) rate = 25.0;
    else if (frameRate == omFrmRate29_97Hz) rate = 29.97;
    else if (frameRate == omFrmRate30Hz) rate = 30.0;
    else rate = 0;

    msg("player %s frame rate = %g\n", gPlrName, rate);
    return true;
}

bool getFsSpace(FUNC_ARGS)
{
    uint_64    total;
    uint_64    free;
    OmPlrError error;
    uint_64    tmp;
    int        len;
    char       totalStr[64];
    char       freeStr[64];

    error = OmPlrClipGetFsSpace (gPlrHand, &total, &free);
    if (error) {
        errMsg("failed to get file system space  %s\n", showError(error));
        return true;
    }

    // convert 64bit binary number to a decimal value in 
    // a string -- for "total available"
    len = 0;
    tmp = 1000000000;
    tmp *= 1000000000;
    while (total > 0) {
        uint num = (uint)(total / tmp);
        if (num != 0) {
            if (len == 0) len += sprintf (totalStr + len, "%3d", num);
            else len += sprintf (totalStr + len, ",%03d", num);
        }
        total %= tmp;
        tmp /= 1000;
    }
    if (len == 0) strcpy (totalStr, "0");

    // convert 64bit binary number to a decimal value in
    //a string -- for "free space"
    len = 0;
    tmp = 1000000;
    tmp *= 1000000;
    while (free > 0) {
        uint num = (uint)(free / tmp);
        if (num != 0) {
            if (len == 0) len += sprintf (freeStr + len, "%3d", num);
            else len += sprintf (freeStr + len, ",%03d", num);
        }
        free %= tmp;
        tmp /= 1000;
    }
    if (len == 0) strcpy (freeStr, "0");

    msg("total bytes: %s  free bytes: %s\n", totalStr, freeStr);
    return true;
}

bool getNumClips(FUNC_ARGS)
{
    OmPlrError error;
    uint     numClips;

    error = OmPlrGetNumClips (gPlrHand, &numClips);
    if (error) {
        errMsg("failed to get number of clips  %s\n", showError(error));
        return true;
    }

    msg("player %s has #%d clips attached to its timeline\n", gPlrName, numClips);
    return true;
}

bool getPlayerName(FUNC_ARGS)
{
    OmPlrError error;
    char       playerName[omPlrMaxPlayerNameLen];

    error = OmPlrGetPlayerName (gPlrHand, playerName, omPlrMaxPlayerNameLen);
    if (error) {
        errMsg("failed to get name of player %s\n", showError(error));
        return true;
    }

    msg("director reports a player name of \"%s\" for this connection\n", playerName);

    return true;
}

bool getPlayerStatus(FUNC_ARGS)
{
    OmPlrError  error;
    OmPlrStatus status;
    char        *pEnableStr;
    char        frameRateStr[8];
    double      freq;
    bool        looping;

    // get the player status
    status.size = sizeof(OmPlrStatus);

    error = OmPlrGetPlayerStatus (gPlrHand, &status);
    if (error) {
        errMsg("failed to get player status: %s\n", showError(error));
        return true;
    }

    if (status.playEnabled && status.recordEnabled) {
        pEnableStr = "record & play enabled";
    }
    else if (status.playEnabled) pEnableStr = "play only";
    else if (status.recordEnabled) pEnableStr = "record only";
    else pEnableStr = "not enabled";


    switch (status.frameRate) {
    case omFrmRate24Hz:
        freq = 24.0;
        break;

    case omFrmRate25Hz:
        freq = 25.0;
        break;

    case omFrmRate29_97Hz:
        freq = 29.97;
        break;

    default: freq = 0.0;
    }
    sprintf(frameRateStr, "%g", freq );

    looping = (status.loopMin != status.loopMax);

    msg("\n Player %s: %s, frame rate %s, looping %s.\n\n", 
        gPlrName, 
        pEnableStr, 
        frameRateStr,
        looping ? "on" : "off");

    msg(" Player timeline status:\n");
    if (!looping) {
        msg(" state     pos        rate    minPos       maxPos       clips  ChangeMarkr\n");
    } else {
        msg(" state     pos        rate    minLoopPos   maxLoopPos   clips  ChangeMarkr\n");
    }

    msg(    " ========  =========  ======  ===========  ===========  =====  ===========\n");
    msg(" %-8s  %-9d  %-6.2lf  %-11d  %-11d  %-5d  %d\n\n",
         stateStr (status.state), 
         status.pos, 
         status.rate,
         (!looping) ? status.minPos : status.loopMin,
         (!looping) ? status.maxPos : status.loopMax,
         status.numClips, 
         status.clipListVersion);


    // do the loaded clips
    if (status.numClips > 0) {
        msg(" First clip attached at %d; end of last clip at %d\n",
            status.firstClipStartPos, 
            status.lastClipEndPos);
        msg(" Current clip is \"%s\" (#%d); curClip attached at timeline %d\n",
            status.currClipName, 
            status.currClipNum, 
            status.currClipStartPos);
        msg(" Current clip attached in/out = %d / %d ; firstFrame / LastFrame = %d / %d \n",
            status.currClipIn, 
            status.currClipOut, 
            status.currClipFirstFrame, 
            status.currClipLastFrame);
    }
    else  msg(" No clips attached.\n");

   // Enhancement -- show .version and .clipListVersion (as in "clipListChangeMarker")

    msg("\n\n");
    return true;
}


bool getPosAndClip(FUNC_ARGS)
{
    OmPlrError      error;
    int           tlinePosition;
    OmPlrClipHandle clipHandle;

    error = OmPlrGetPosAndClip(gPlrHand, &tlinePosition, &clipHandle);
    if (error) {
        errMsg("unable to get position & clipHandle:   %s\n", showError(error));
        return true;
    }
    msg("timeline position currently at %d -- and showing clip with handle %#08x\n", 
        tlinePosition, 
        clipHandle);
    return true;
}    

/*
This function returns "the position in the current clip"
This is a number relative to the clip's frame numbering.
You can get the same information by using the OmPlrGetPlayerStatus function and doing the calculation
   " pos - curClipStartPos + curClipIn"
*/
bool getPosInClip(FUNC_ARGS) 
{
    OmPlrError error;
    uint       clipBasedPosition;

    error = OmPlrGetPosInClip(gPlrHand, &clipBasedPosition);
    if (error) {
        errMsg("unable to get position in current clip:   %s\n", showError(error));
        return true;
    }
    msg("currently at position %d within current clip\n", clipBasedPosition);
    return true;
}

/*
This function returns "the position of the current clip on the timeline", 
its attach point. This info is also available as part of getClipData.
*/
bool getPosOfClip(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle clipHandle;
    int             clipIndex;
    int           clipAttachPos;

    if (numWords < 2) return false;

    if (!mapClipIndexToHandle(word[1], &clipHandle, &clipIndex)) {
        return(false);
    }

    // SHOW clip Data
    error = OmPlrGetPosOfClip(gPlrHand, clipHandle, &clipAttachPos);
    if (error) {
        errMsg("unable to get position for clip: %s\n", showError(error));
        return true;
    }
    if (clipIndex < 0)  {
        msg("Clip (handle %#x) on timeline attached at %d.\n", 
            clipHandle,
            clipAttachPos);
    } else {
        msg("Clip at index %d on timeline attached at %d.\n", 
            clipIndex,
            clipAttachPos);
    }
    return true;
}


bool getRecordTime(FUNC_ARGS)
{
    OmPlrError error;
    uint     recordSeconds;

    error = OmPlrGetRecordTime (gPlrHand, &recordSeconds);
    if (error) {
        errMsg("failed to get record time of player %s  %s\n", 
               gPlrName,
               showError(error));
        return true;
    }

    msg("player %s can record for %d seconds (assuming format of this player)\n", 
        gPlrName, 
        recordSeconds);

    return true;
}


// NOTE: this information is also available in the player STATUS information
bool getState(FUNC_ARGS)
{
    OmPlrError error;
    OmPlrState state;

    error = OmPlrGetState (gPlrHand, &state);
    if (error) {
        errMsg("failed to get state of player %s  %s\n", 
               gPlrName,
               showError(error));
        return true;
    }

    msg("player %s is in %s state\n", gPlrName, stateStr (state));

    return true;
}


bool getTcgInsertion(FUNC_ARGS)
{
    OmPlrError  error;
    bool        playInsert;      // returned true if insert on play is enabled
    bool        recordInsert;    // returned true if insert on record is enabled

    error = OmPlrGetTcgInsertion(gPlrHand, &playInsert, &recordInsert);
    if (error) {
        errMsg("failed to get TCG insertion for player %s: %s\n",
                gPlrName, 
                showError(error));
        return true;
    }
    
    if (playInsert && recordInsert) msg("Timecode is inserted on both play and record.\n");
    else if (playInsert) msg("Timecode is inserted on play only.\n");
    else if (recordInsert) msg("Timecode is inserted on record only.\n");
    else msg("Timecode is not being inserted on play or record.\n");

    return true;
}

bool getTcgMode(FUNC_ARGS)
{
    OmPlrError   error;
    OmPlrTcgMode mode;
    char *       theMode = "unknown";

    error = OmPlrGetTcgMode(gPlrHand, &mode);
    if (error) {
        errMsg("failed to get TCG mode for player %s: %s\n",
                gPlrName, 
                showError(error));
        return true;
    }
    
    switch (mode) {
        case omPlrTcgModeHold:
            theMode = "hold";
            break;
        case omPlrTcgModeFreeRun:
            theMode = "free-run";
            break;
        case omPlrTcgModeLockedTimeline:
            theMode = "locked to timeline";
            break;
        case omPlrTcgModeLockedClip:
            theMode = "locked to current clip on timeline";
            break;
    }

    msg("Timecode generator mode is %s.\n", theMode); 
    
    return true;
}


bool getClipData(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle clipHandle;
    int             clipIndex;
    int           clipAttachPoint;
    uint          clipIn;
    uint          clipOut;

    if (numWords < 2) return false;

    if (!mapClipIndexToHandle(word[1], &clipHandle, &clipIndex)) {
        return(false);
    }

    // SHOW clip Data
    error = OmPlrGetClipData(gPlrHand, clipHandle, &clipAttachPoint, &clipIn, &clipOut, /*clipLen*/ 0);
    if (error) {
        errMsg("unable to get data for clip:   %s\n", showError(error));
        return true;
    }
    if (clipIndex < 0)  {
        msg("Clip (handle %#08x) on timeline attached at %d and has In=%d and Out=%d\n", 
            clipHandle,
            clipAttachPoint, 
            clipIn, 
            clipOut);
    } else {
        msg("Clip at index %d on timeline attached at %d and has In=%d and Out=%d\n", 
            clipIndex, 
            clipAttachPoint, 
            clipIn, 
            clipOut);
    }
    return true;
}

bool setClipData(FUNC_ARGS)
{
    OmPlrError      error;
    OmPlrClipHandle clipHandle;
    int             clipIndex;
    uint          clipIn;
    uint          clipOut;
    OmPlrShiftMode  shift = omPlrShiftModeAuto;

    if (numWords < 4) return false;

    if (!mapClipIndexToHandle(word[1], &clipHandle, &clipIndex)) {
        return(false);
    }

    // ElSE -- set clip data

    clipIn = strtol (word[2], 0, 0);
    if (clipIn < 0) clipIn = omPlrClipDefaultIn;
    clipOut = strtol (word[3], 0, 0);
    if (clipOut < 0) clipOut = omPlrClipDefaultOut;

    if (numWords > 4) {
        // 4th argument is SHIFT parameter -- "-" or "0" or "+"
        if (!mapArgToShift(word[4], &shift)) return(false);
    }

    error = OmPlrSetClipData (gPlrHand, clipHandle, (uint)clipIn, (uint)clipOut, omPlrClipDefaultLen, shift);
    if (error) {
        errMsg("failed to set attached clip points on player %s  %s\n", 
               gPlrName,
               showError(error));
        return true;
    }
    // else
    msg("set in/out points for clip at index %d (handle %#08x) on timeline (%s)\n", 
        clipIndex, 
        clipHandle, 
        printShift(shift));

    return true;
}


bool getClipDir(FUNC_ARGS)
{
    OmPlrError error;
    char       clipDir[omPlrMaxClipDirLen];

    error = OmPlrClipGetDirectory (gPlrHand, clipDir, omPlrMaxClipDirLen);
    if (error) {
        errMsg("failed to get clip directory   %s\n", showError(error));
        return true;
    }
    msg("clip directory is %s\n", clipDir);
    return true;
}


bool setClipDir(FUNC_ARGS)
{
    OmPlrError error;

    if (numWords > 1) {
        char *pClipDir = word[1];

        error = OmPlrClipSetDirectory (gPlrHand, pClipDir);
        if (error) {
            errMsg("failed to set clip directory to %s   %s\n", 
                   pClipDir,
                   showError(error));
        }
        strcpy(gClipDirectoryName, pClipDir);   // remember clip directory -- used by callback code
        return true;
    } else {
        errMsg("No clip directory specified.\n");
        return false;
    }
}


// NOTE: this information is also available in the player STATUS information
bool getMax(FUNC_ARGS)
{
    OmPlrError error;
    int        pos;

    error = OmPlrGetMaxPos (gPlrHand, &pos);
    if (error) {
        errMsg("failed to get maximum position of player %s  %s\n",
               gPlrName, 
               showError(error));
    }
    else  msg("player %s max position set to %d\n", gPlrName, pos);
    return true;
}


bool setMax(FUNC_ARGS)
{
    OmPlrError error;
    int        pos;

    if (numWords > 1) {
        pos = strtol (word[1], 0, 0);
        error = OmPlrSetMaxPos (gPlrHand, pos);
        if (error) {
            errMsg("failed to set maximum position on player %s  %s\n",
                   gPlrName, 
                   showError(error));
            return true;
        }
    } else {
        errMsg("No maximum position specified,\n");
        return false;
    }
    return true;
}


// NOTE: this information is also available in the player STATUS information
bool getMin(FUNC_ARGS)
{
    OmPlrError error;
    int        pos;

    error = OmPlrGetMinPos (gPlrHand, &pos);
    if (error) {
        errMsg("failed to get minimum position on player %s  %s\n",
               gPlrName, 
               showError(error));
    }
    else  msg("player %s min position set to %d\n", gPlrName, pos);
    return true;
}

bool setMin(FUNC_ARGS)
{
    OmPlrError error;
    int        pos;

    if (numWords > 1) {
        pos = strtol (word[1], 0, 0);
        error = OmPlrSetMinPos (gPlrHand, pos);
        if (error) {
            errMsg("failed to set minimum position on player %s  %s\n",
                   gPlrName, 
                   showError(error));
            return true;
        }
    } else {
        errMsg("No minimum position specified.\n");
        return false;
    }
    return true;
}

// NOTE: this information is also available in the player STATUS information
bool getPos(FUNC_ARGS)
{
    int        pos;
    OmPlrError error;

    error = OmPlrGetPos (gPlrHand, &pos);
    if (error) {
        errMsg("failed to get position of player %s  %s\n", 
               gPlrName,
               showError(error));
        return true;
    }
    msg("player %s is at %d\n", gPlrName, pos);
    return true;
}

bool setPos(FUNC_ARGS)
{
    int        pos;
    OmPlrError error;

    if (numWords > 1) {
        pos = strtol (word[1], 0, 0);
        error = OmPlrSetPos (gPlrHand, pos);
        if (error)
            errMsg("failed to set position on player %s  %s\n", gPlrName,
                    showError(error));
        return true;
    } else {
        errMsg("No position specified.\n");
        return false;
    }
    return true;
}

bool getPlayEnabled(FUNC_ARGS)
{
    OmPlrError error;
    bool       enabled;

    error = OmPlrPlayEnabled (gPlrHand, &enabled);
    if (error) {
        errMsg("failed to get play-enabled flag for player %s  %s\n",
                gPlrName, 
                showError(error));
        return true;
    }

    msg("player %s is %senabled for playback.\n", gPlrName, enabled ? "" : "not ");
    return true;
}


bool getRate(FUNC_ARGS)
{
    OmPlrError error;
    double     rate;

    error = OmPlrGetRate (gPlrHand, &rate);
    if (error) {
        errMsg("failed to get play rate for player %s  %s\n",
                gPlrName, 
                showError(error));
        return true;
    }

    msg("player %s playback rate = %g\n", gPlrName, rate);
    return true;
}


bool getRecordEnabled(FUNC_ARGS)
{
    OmPlrError error;
    bool       enabled;

    error = OmPlrRecordEnabled (gPlrHand, &enabled);
    if (error) {
        errMsg("failed to get record-enabled flag for player %s  %s\n",
                gPlrName, 
                showError(error));
        return true;
    }

    msg("player %s is %senabled for recording.\n", gPlrName, enabled ? "" : "not ");
    return true;
}



bool getLoop(FUNC_ARGS)
{
    int   in;
    int   out;

    char *ptr = word[1];
    if (*ptr == '-') ptr++;

    OmPlrGetLoop (gPlrHand, &in, &out);
    
    if (in != out) msg("player %s looping for %d frames\n", 
                       gPlrName, 
                       out - in);
    else msg("player %s looping turned off\n", gPlrName);
    return true;
}


bool setLoop(FUNC_ARGS)
{
    int        in;
    int        out;
    OmPlrError  error;

    char *ptr = word[1];
    if (*ptr == '-') ptr++;

    if (numWords == 3) {
        in = strtol (word[1], 0, 0);
        out = strtol (word[2], 0, 0);
    } else {
        errMsg("wrong number of parameters.\n");
        return false;
    }

    error = OmPlrLoop (gPlrHand, in, out);
    if (error) errMsg("failed to set loop mode for player %s  %s\n", 
                      gPlrName,
                      showError(error));
    else if (in != out) msg("player %s looping for %d frames\n", 
                            gPlrName, 
                            out - in);
    else msg("player %s looping turned off\n", gPlrName);
    return true;
}


bool gotoTimecode(FUNC_ARGS)
{
    OmPlrError  error;
    OmTcData    tc;
    uint        hh = 0, mm = 0, ss = 0, ff = 0, df = 0, cf = 0, userBits = 0;
    uint        timeoutMsecs = 2000;        // default to 2 seconds

    // Are the last two parms  "t=" and some number?
    if ((numWords > 5) && (word[numWords - 2][0] == 't'))  {
        timeoutMsecs = strtoul(word[numWords -1], 0, 0);
        numWords -= 2;
    }
    if (numWords > 1) hh = strtoul(word[1], 0, 10);
    if (numWords > 2) mm = strtoul(word[2], 0, 10);
    if (numWords > 3) ss = strtoul(word[3], 0, 10);
    if (numWords > 4) ff = strtoul(word[4], 0, 10);
    if (numWords > 5) df = strtoul(word[5], 0, 0);
    if (numWords > 6) cf = strtoul(word[6], 0, 0);
    if (numWords > 7) userBits = strtoul(word[7], 0, 0);

    tc.Zero();
    tc.ZeroUserbits();
    tc.SetTime(hh, mm, ss, ff, df, cf);
    tc.InsertUserbits(userBits);

    error = OmPlrGoToTimecode (gPlrHand, tc, timeoutMsecs);
    if (error) errMsg("failed to position player %s   %s\n", 
                      gPlrName,
                      showError(error));
    else msg("player %s positioned\n", gPlrName);

    return true;
}


// if no argument, open with a NULL player. If called as "open1" the callback 
// version will be called (OmPlrOpen1).
bool open(FUNC_ARGS)
{
    OmPlrHandle newPlrHand;
    char        *pNewPlrName = NULL;
    OmPlrError  error;

    bool noCallback = (stricmp(word[0], "open1") == 0)? false : true;

    if (numWords < 3) return(false);
    if (word[1][0] != '.')  {
        strcpy(gDirName, word[1]);
    }
    if (stricmp(word[2],"null") != 0)  {
        pNewPlrName = word[2];
    }

    if (gDirName[0] == '\0') {
        errMsg("director not selected -- aborting Open\n");
        return(true);
    }

     // if had been open
    if (gPlrHand != 0)  {
        OmPlrClose(gPlrHand);    
        msg("WARNING: opening new connection without first closing existing one!\n");        
        msg("(Old connection closed, but you should call close explicitly first.)\n");        
    }
    gPlrHand = 0;       // about to get a new one
    gPlrName[0] = '\0';  // we would have lost/abandoned any unclosed connection!!!
    gClipDirectoryName[0] = '\0';       // clip directory goes back to default
    gClipExtensionList[0] = '\0';       // clip directory goes back to default

    if (noCallback) error = OmPlrOpen(gDirName, pNewPlrName, &newPlrHand);
    else error =  OmPlrOpen1(gDirName, pNewPlrName, &newPlrHand, connectCallback);

    if (error == omPlrNameNotExist) {
        msg("Player %s does not exist.\n", word[1]);
    } else if (error) {
        errMsg("Failed to connect to director %s. (%s)\n", gDirName, showError(error));
    } else {
        gPlrHand = newPlrHand;
        if (pNewPlrName != 0) {
            strcpy(gPlrName, pNewPlrName);
            msg("Successfully opened connection using handle %#08x to player \"%s\"\n", 
            gPlrHand, gPlrName);
        } else {
            msg("Successfully opened connection using handle %#08x -- NULL player.\n", gPlrHand);
        }
    }

    return true;
   
}    

bool play(FUNC_ARGS) 
{
    OmPlrError error;
    double     rate = 1.0;

    if (numWords > 1) sscanf (word[1], "%lf", &rate);

    error = OmPlrPlay (gPlrHand, rate);
    if (error) errMsg("failed to play player %s   %s\n", 
                      gPlrName,
                      showError(error));
    else msg("player %s started at %5.2f\n", gPlrName, rate);
    return true;
}

bool playAt(FUNC_ARGS)
{
    OmPlrError error;
    double     rate;
    int        sched;

    if (numWords < 2) return(false);
        
    sched = strtol (word[1], 0, 0);

    if (numWords > 2) sscanf (word[2], "%lf", &rate);
    else rate = 1.0;

    {
        int pos;
        uint housePos;

        error = OmPlrGetTime (gPlrHand, 
                            &pos, 
                            &housePos, 
                            /*housePosF*/ 0, 
                            /*tc*/ 0, 
                            /*unused*/ 0, 
                            /*unused*/ 0);
        msg("player %s playAt for sched = 0x%08X (%d), time is now 0x%08X (%d)\n", 
            gPlrName, 
            sched, 
            sched, 
            housePos, 
            housePos);
    }

    error = OmPlrPlayAt (gPlrHand, sched, rate);
    if (error) errMsg("failed to \"playAt\" player %s  %s\n", 
                      gPlrName,
                      showError(error));
    // success message -- use the above message
    return true;
}


bool playDelay(FUNC_ARGS)
{
    OmPlrError error;
    double     rate;
    int        delay;

    if (numWords < 2) return(false);
        
    delay = strtol (word[1], 0, 0);

    if (numWords > 2) sscanf (word[2], "%lf", &rate);
    else rate = 1.0;


    error = OmPlrPlayDelay (gPlrHand, delay, rate);
    if (error) errMsg("failed to \"play delay\" player %s  %s\n", 
                      gPlrName,
                      showError(error));
    else msg("player %s playDelay %d\n", gPlrName, delay);
    return true;
}


bool record(FUNC_ARGS)
{
    OmPlrError error;

    error = OmPlrRecord (gPlrHand);
    if (error) errMsg("player %s failed to enter record state   %s\n",
                      gPlrName, 
                      showError(error));
    return true;
}

    

bool recordAt(FUNC_ARGS)
{
    OmPlrError error;
    int        sched;

    if (numWords < 2) return(false);
        
    sched = strtol (word[1], 0, 0);

    {
        int pos;
        uint housePos;

        error = OmPlrGetTime (gPlrHand, 
                            &pos, 
                            &housePos, 
                            /*housePosF*/ 0, 
                            /*tc*/ 0, 
                            /*unused*/ 0, 
                            /*unused*/ 0);
        msg("player %s recordAt for sched = 0x%08X (%d), time is now 0x%08X (%d)\n", 
            gPlrName, 
            sched, 
            sched, 
            housePos, 
            housePos);
    }
    error = OmPlrRecordAt (gPlrHand, sched);
    if (error) errMsg("player %s failed to recordAt   %s\n", 
                      gPlrName,
                      showError(error));
    return true;
}


bool recordDelay(FUNC_ARGS)
{
    OmPlrError error;
    int        delay;

    if (numWords < 2) return(false);
        
    delay = strtol (word[1], 0, 0);

    error = OmPlrRecordDelay (gPlrHand, delay);
    if (error) errMsg("player %s failed to recordDelay   %s\n",
                      gPlrName,
                      showError(error));
    else msg("player %s recordDelay %d\n", gPlrName, delay);
    return true;
}


bool recordTime(FUNC_ARGS)
{
    uint seconds;
    
    OmPlrError error = OmPlrGetRecordTime (gPlrHand, &seconds);
    if (error) {
        errMsg("failed to get record time for player %s  %s\n",
                gPlrName, showError(error));
        return true;
    }
    msg("player %s available record time is %u seconds\n", gPlrName, seconds);
    return true;
}


bool setMaxPosMax(FUNC_ARGS)
{
    OmPlrError error;

    error = OmPlrSetMaxPosMax (gPlrHand);
    if (error) {
        errMsg("failed to set timeline limits for player %s  %s\n", 
               gPlrName,
               showError(error));
        return true;
    }

    msg("Set Maximum of timeline using clip with biggest attachment point\n");

    return true;
    
}    

bool setMinMaxPosToClip(FUNC_ARGS)
{
    OmPlrError      error;
    int             clipIndex;
    OmPlrClipHandle clipHandle;

    if (numWords < 2) return false;

    if (!mapClipIndexToHandle(word[1], &clipHandle, &clipIndex)) {
        return(false);
    }
    
    error = OmPlrSetMinMaxPosToClip(gPlrHand, clipHandle);
    if (error) {
        errMsg("failed to set timeline limits for player %s  %s\n", 
                gPlrName,
                showError(error));
        return true;
    }

    msg("Set timeline Min/Max using limits of clip attached at index %d (handle %#08x)\n",
        clipIndex, 
        clipHandle);

    return true;
}    

bool setMinPosMin(FUNC_ARGS)
{
    OmPlrError error;

    error = OmPlrSetMinPosMin (gPlrHand);
    if (error) {
        errMsg("failed to set timeline limits for player %s  %s\n", 
               gPlrName,
               showError(error));
        return true;
    }

    msg("Set Mimimum of timeline using clip with smallest attachment point\n");

    return true;
    
}    


bool step(FUNC_ARGS)
{
    OmPlrError error;
    int        step;

    if (numWords > 1) step = strtol (word[1], 0, 0);
    else step = 1;

    error = OmPlrStep (gPlrHand, step);
    if (error) errMsg("failed to step player %s   %s\n", 
                      gPlrName,
                      showError(error));
    else msg("player %s stepped for %d steps\n", gPlrName, step);

    return true;
}


bool stop(FUNC_ARGS)
{
    OmPlrError error;

    error = OmPlrStop (gPlrHand);
    if (error) errMsg("failed to stop player %s   %s\n", 
                      gPlrName,
                      showError(error));
    else msg("player %s stopped\n", gPlrName);

    return true;
}


bool time(FUNC_ARGS)
{
    int         pos;
    uint        housePos;
    uint        housePosF;
    OmTcData    refVitc;
    OmTcData    tcg;
    OmTcData    videoTc;
    OmPlrError  error;
    double      houseTime;
    char        vitcTimeStr[64];
    char        tcgTimeStr[64];
    char        tcrTimeStr[64];

    error = OmPlrGetTime (gPlrHand, 
                          &pos, 
                          &housePos, 
                          &housePosF, 
                          &refVitc,
                          &tcg, 
                          &videoTc);
    if (error) {
        errMsg("failed to get time   %s\n", showError(error));
        return true;
    }

    houseTime = housePos + (double)housePosF/0x10000/0x10000;
    msg("%s pos:%d  house=%.4lf  (0x%08X) \n", 
        gPlrName, 
        pos, 
        houseTime, 
        housePos);

    showTimeUser(refVitc, vitcTimeStr);
    msg("   vitc reference = %s\n",  vitcTimeStr);

    showTimeUser(tcg, tcgTimeStr);
    msg("   internal tc Generator = %s\n", tcgTimeStr);

    showTimeUser(videoTc, tcrTimeStr);
    msg("   internal tc Reader   =  %s\n", tcrTimeStr);

    return true;
}

bool timeDate(FUNC_ARGS)
{
    int         pos;
    uint        housePos;
    uint        housePosF;
    uint        dirTimeSeconds;
    uint        dirTimeMilliseconds;
    OmTcData    refVitc;
    OmTcData    tcg;
    OmTcData    videoTc;
    OmPlrError  error;
    double      houseTime;
    char        vitcTimeStr[64];
    char        tcgTimeStr[64];
    char        tcrTimeStr[64];

    error = OmPlrGetTime1 (gPlrHand, 
                          &pos, 
                          &housePos, 
                          &housePosF, 
                          &refVitc,
                          &tcg, 
                          &videoTc,
                          &dirTimeSeconds,
                          &dirTimeMilliseconds);
    if (error) {
        errMsg("failed to get time   %s\n", showError(error));
        return true;
    }

    houseTime = housePos + (double)housePosF/0x10000/0x10000;
    msg("%s pos:%d  house=%.4lf  (0x%08X) \n", 
        gPlrName, 
        pos, 
        houseTime, 
        housePos);

    showTimeUser(refVitc, vitcTimeStr);
    msg("   vitc reference = %s\n",  vitcTimeStr);

    showTimeUser(tcg, tcgTimeStr);
    msg("   internal tc Generator = %s\n", tcgTimeStr);

    showTimeUser(videoTc, tcrTimeStr);
    msg("   internal tc Reader   =  %s\n", tcrTimeStr);

    if (dirTimeSeconds != 0) {
        struct tm *t1 = localtime((const time_t *)&dirTimeSeconds);
        msg("   director time: %02u/%02u/%04u %02u:%02u:%02u.%03d\n",
            t1->tm_mon + 1, t1->tm_mday, t1->tm_year + 1900, t1->tm_hour,
            t1->tm_min, t1->tm_sec, dirTimeMilliseconds);
    } else  {
        msg("   director time: seconds = 0\n");
    }
    return true;
}

bool setRetryOpen(FUNC_ARGS)
{
    OmPlrError error;
    char       *ptr;
    bool       retryYes;

    if (numWords < 2) return false;

    // argument can be either "-on" or "on" or "-off" or "off"
    ptr = word[1];
    if (*ptr == '-') ptr++;     // skip over any leading "-"
    if (stricmp (ptr, "on") == 0) retryYes = 1;
    else if (stricmp (ptr, "off") == 0) retryYes = 0;
    else return false;

    error = OmPlrSetRetryOpen (gPlrHand, retryYes);
    if (!error){
        if (retryYes) msg("Library/dll will try to reopen failed connections\n");
        else msg("Library/dll will NOT attempt to reopen failed connections\n");
    }
    else errMsg("failed to set the reopen property: %s\n", showError(error));
       
    return true;
}    


bool setTcgData(FUNC_ARGS)
{
    OmPlrError  error;
    OmTcData    tc;
    bool        bUserBitsOnly = false;
    uint        hh = 0, mm = 0, ss = 0, ff = 0, df = 0, cf = 0, userBits = 0;

    if (numWords > 1 && toupper(word[1][0]) == 'U') {
        bUserBitsOnly = true;
        if (numWords > 2) userBits = strtoul(word[2], 0, 0);
    }
    else {
        if (numWords > 1) hh = strtoul(word[1], 0, 10);
        if (numWords > 2) mm = strtoul(word[2], 0, 10);
        if (numWords > 3) ss = strtoul(word[3], 0, 10);
        if (numWords > 4) ff = strtoul(word[4], 0, 10);
        if (numWords > 5) df = strtoul(word[5], 0, 0);
        if (numWords > 6) cf = strtoul(word[6], 0, 0);
        if (numWords > 7) userBits = strtoul(word[7], 0, 0);
    }

    tc.Zero();
    tc.ZeroUserbits();
    tc.SetTime(hh, mm, ss, ff, df, cf);
    tc.InsertUserbits(userBits);

    error = OmPlrSetTcgData(gPlrHand, tc, bUserBitsOnly);
    if (error) {
        errMsg("failed to set TCG data for player %s: %s\n",
                gPlrName, 
                showError(error));
        return true;
    }

    if (bUserBitsOnly) msg("Set user bits only to %#x\n", userBits);
    else msg("Set TCG to %02d:%02d:%02d:%02d, df=%d, cf=%d, user bits %#x.\n",
             hh,
             mm,
             ss,
             ff,
             df,
             cf,
             userBits);

    return true;
}


bool setTcgInsertion(FUNC_ARGS)
{
    OmPlrError  error;
    bool        playInsert = false;   // set true to enable timecode insert during play
    bool        recordInsert = false; // set true to enable timecode insert during record
    
    for (int i = 1; i < numWords; i++) {
        if (toupper(word[i][0]) == 'P') playInsert = true;
        if (toupper(word[i][0]) == 'R') recordInsert = true;
    }

    error = OmPlrSetTcgInsertion(gPlrHand, playInsert, recordInsert);
    if (error) {
        errMsg("failed to set timecode insertion for player %s: %s\n",
                gPlrName, 
                showError(error));
        return true;
    }
    
    msg("Timecode insertion is now %s for playback and %s for recording.\n",
        (playInsert ? "ON" : "off"),
        (recordInsert ? "ON" : "off"));

    return true;
}

bool setTcgMode(FUNC_ARGS)
{
    OmPlrError   error;
    OmPlrTcgMode mode;     // new timecode generator mode
    char         *modeStr;

    if (numWords != 2) return false;

    switch (toupper(word[1][0])) {
    case 'H':
        mode = omPlrTcgModeHold;
        modeStr = "hold";
        break;
    case 'F':
        mode = omPlrTcgModeFreeRun;
        modeStr = "free-run";
        break;
    case 'L':
        mode = omPlrTcgModeLockedTimeline;
        modeStr = "locked-to-timeline";
        break;
    case 'C':
        mode = omPlrTcgModeLockedClip;
        modeStr = "locked-to-clip";
        break;
    default:
        errMsg("Unknown mode selection. ");
        return false;
    } // switch

    error = OmPlrSetTcgMode(gPlrHand, mode);
    if (error) {
        errMsg("failed to set TCG mode for player %s: %s\n",
                gPlrName, 
                showError(error));
        return true;
    }
    
    msg("Timecode generation is set to %s mode.\n", modeStr);

    return true;
}


bool noop(FUNC_ARGS)
{
    msg("This command is not implemented yet.\n");
    return true;
}


bool getClipExtList(FUNC_ARGS)
{
    OmPlrError error;
    char extList[omPlrMaxClipExtListLen];

    error = OmPlrClipGetExtList (gPlrHand, extList, omPlrMaxClipDirLen);
    if (error) {
        errMsg("failed to get clip extension list   %s\n", showError(error));
        return true;
    }
    msg("clip extension list is %s\n", extList);
    return true;
}


bool setClipExtList(FUNC_ARGS)
{
    OmPlrError error;

    if (numWords > 1) {
        char *pExtList = word[1];

        error = OmPlrClipSetExtList (gPlrHand, pExtList);
        if (error) {
            errMsg("failed to set clip extension list to %s   %s\n", 
                   pExtList,
                   showError(error));
        }
        strcpy(gClipExtensionList, pExtList);   // remember clip extension list -- used by callback code
        return true;
    } else {
        errMsg("No clip extension list specified.\n");
        return false;
    }
}

bool getAppClipExtList(FUNC_ARGS)
{
    OmPlrError error;
    char appExtList[omPlrMaxClipExtListLen];

    error = OmPlrGetAppClipExtList(gPlrHand, appExtList, omPlrMaxClipExtListLen-1);
    if (error) {
        errMsg("failed to get \"application\" clip extension list for this player: %s\n", showError(error));
        return true;
    }
    // else
    msg("Suggested clip extension list for this player is \"%s\"\n", appExtList);
    return true;
}    



#if 0
// Extract data from a clip, for example closed caption data.
// Extract data of type dataType from clip pClipName. Start at frame
// startFrame. Extract numFrames frames. Extract data into buffer pData.
// Set pDataSize to the size of the pData buffer. Upon successful return,
// pDataSize returns the amount of data extracted.
OmPlrError OmPlrClipExtractData(
    OmPlrHandle plrHandle,    // handle returned from OmPlrOpen()
    const char *pClipName,    // name of clip
    uint startFrame,          // frame number to start extraction
    uint numFrames,           // number of frames to extract
    OmPlrClipDataType dataType, // type of data to extract
    unsigned char *pData,     // buffer to receive extracted data
    uint *pDataSize);          // size of buffer or data (in bytes)


enum OmPlrClipDataType {
    omPlrClipDataUnknown,
    omPlrClipDataCcField1,  // 2 bytes of closed caption from field 1
    omPlrClipDataCcField2,  // 2 bytes of closed caption from field 2
    omPlrClipDataCcFrame,   // 4 bytes of closed caption
    omPlrClipDataTimecode,  // 4 bytes of timecode (8 TC nibbles of OmTcData)
    omPlrClipDataUserbits,  // 4 bytes of userbits (8 UB nibbles of OmTcData)
    omPlrClipDataTimeUser,  // 4 bytes of timecode followed by 4 bytes userbits
    omPlrClipDataOmTcData,  // 8 bytes in OmTcData format
    omPlrClipDataRawVbi,  // OmPlrRawVbiHeader followed by 1440 bytes per line.
};
#endif

void hexDump(unsigned char * pData, int byteCount)
{
    int lineWidth = 16;  // will change for the last line
    
    for ( int bc = byteCount; bc > 0; bc -= lineWidth) {
        if (bc < lineWidth)
            lineWidth = bc;  // truncate last line
        for (int lineBytes = 0; lineBytes < lineWidth; lineBytes++) {
            printf("0x%02x ", *pData++);
            if (lineBytes == 7)
                printf(" ");  // extra space between 8th and 9th bytes
        }
        printf("\n");
    }
}

// As a simple example, 
//  Extract timecode from 3 consequencutive frames starting at frame of your choice
// The argument is the clip name and the frame number
bool clipExtractData(FUNC_ARGS)
{
    OmPlrError      error;
    int             startFrame;
    char *clipName;

    if (numWords < 3)  {  // need clipName & frameNumber.  Optional framecount
        return false;
    }

    // get arguments
    // NOTE: can't use the default arg value
    clipName = word[1];
    startFrame = strtol (word[2], 0, 0);

    // frameCount is optional
    uint frameCount = 3;
    if (numWords >= 4)
        frameCount = strtol (word[3], 0, 0);

    // Konstants for this example
    OmPlrClipDataType dataType = omPlrClipDataTimeUser;
    unsigned int dataSize = 0x100;
    unsigned char * pData = (unsigned char *) malloc(dataSize);
    if (pData == 0)
        return false;

    error = OmPlrClipExtractData (gPlrHand, clipName, startFrame, frameCount,
            dataType, pData, &dataSize);
    if (error) {
        errMsg("failed to extract data from clip %s  %s\n", clipName, showError(error));
    } else {
        msg(" successfully extracted %d bytes data from clip \"%s\" \n"
        " started at frame %d and extract from next %d frames;\n", 
                dataSize, clipName, startFrame, frameCount);
        // do a hex dump in lines of 16
        hexDump(pData, dataSize);
    } 
    free(pData);
    return true;
        
}

