/*********************************************************************

 Filename:    opcTester.cpp

 Description: MAIN for "Omneon Player Control API Tester".

 Copyright (c) 1998-2001 Omneon Video Networks (TM)

 OMNEON VIDEO NETWORKS 

***********************************************************************/

/** include files **/
#ifdef WIN32
#include <windows.h>        // define HANDLE and all kinds of stuff
#else
#include <unistd.h>
#include <cstdlib>
#endif
#include <string.h>
#include <stdarg.h>
#include "opctester.h"

/** local definitions **/

/* default settings */

/** external functions **/
// see opcTester.h

/** external data **/

/** public data **/
// Global data for this application
char gDirName[128];
char gPlrName[omPlrMaxPlayerNameLen];
char gClipDirectoryName[omPlrMaxClipDirLen];
char gClipExtensionList[omPlrMaxClipExtListLen];
OmPlrHandle  gPlrHand;
OmPlrClipCopyHandle gCopyHand;

OmPlrError gError;

int  gHeight = 24;
bool gInteractive = true;

/** private data **/
// Local data  
extern cmdList_t cmdList[];     // in this file but down at the bottom


/** public functions **/
// see opcTester.h

/** private functions **/
// Local function prototypes  
LOCAL bool director(FUNC_ARGS);
LOCAL void testerApp (char *scriptFile, bool redirStdin);
LOCAL void printHelpMsg(cmdList_t *cmd);

short fredie;
long loneOne;
int intOne;

// usage: opctester [-f scriptFile] [-e execString] [director [playerName]]
int main(int argc, char* argv[])
{
    char *dirName = 0;
    char *OmPlrName = 0;
    char *scriptFile = 0;
    bool redirStdin = false;
    int i = 1;

    gDirName[0] = 0;
    gPlrName[0] = 0;
    gClipDirectoryName[0] = 0;
    gClipExtensionList[0] = 0;
    gPlrHand = 0;
    gCopyHand = 0;    

	OmMediaSummary aaa;


	wprintf(L"%3d%% [",120);

	wprintf(L" %d", (int)sizeof(OmMediaSummary));
	
	// parse command line
    while (i < argc) {
        if ( *argv[i] == '-') {
            if (strnicmp(argv[i], "-f", 2) == 0) {
                if (strlen(argv[i]) > 2) {
                    scriptFile = argv[i] + 2;
                }
                else {
                    i++;
                    if (i < argc)
                        scriptFile = argv[i];
                    else {
                        errMsg("-f option requires a filename\n");
                        return 0;
                    }
                }
            } else if (strcmp(argv[i], "-") == 0) {        // ie, the argument is exactly "-" 
                redirStdin = true;
            }
            else {
                msg("usage: opctester [- | -f scriptFile]  [director [playerName]]\n");
            }
        }
        else if (dirName == 0)
            dirName = argv[i];
        else if (OmPlrName == 0)
            OmPlrName = argv[i];

        i++;
    }

    if (dirName) {
        char dummy[3][FUNC_WORDSIZE];
        dummy[0][0] = 0;
        strcpy(dummy[1], dirName);
        if ((OmPlrName == 0) || (stricmp(OmPlrName, "null") == 0))
            OmPlrName = "";
        strcpy(dummy[2], OmPlrName);
        director(3, dummy);
    }

    testerApp(scriptFile, redirStdin);

    return 0;
}


void testerApp (char *scriptFile, bool redirStdin)
{
    char        promptStr[omPlrMaxPlayerNameLen + 8];
    char        input[4096];
    char        *ptr;
    char        word[MAX_WORDS][FUNC_WORDSIZE];
    bool        haveMore;
    bool        haveInput;
    char *cmdName;
    cmdList_t *thisCmd;
    int numWords;

    msg("\n\n\t    Welcome to the Omneon Player Control API tester\n\t\t\t(version %s)\n\n", TESTER_VERSION_STR);

    if (redirStdin)  {
        gInteractive = false;
    }
    haveMore = false;
    while (1) {
        if (scriptFile) {
            sprintf (input, "source %s", scriptFile);
            scriptFile = 0;
            ptr = input;
            haveMore = true;
            gInteractive = false;
        }

        if (!haveMore) {

            // get input
            ptr = input;
            input[0] = 0;

            if (!redirStdin) {
                OmPlrStatus   status;

                gInteractive = true;    // after end of scriptFile and if not redirected
                if (gPlrHand == 0) {
                    strcpy (promptStr, "no Director");
                } else if (gPlrName[0])  {
                    strcpy (promptStr, gPlrName);
                    // Test to see if already sitting at a limit
                    status.size = sizeof(OmPlrStatus);
                    if (OmPlrGetPlayerStatus (gPlrHand, &status) == omPlrOk) {
                        if (status.pos >= status.maxPos-1) {
                            sprintf (promptStr + strlen(promptStr), " %d (max)", status.pos);
                        } else if (status.pos <= status.minPos)  {
                            sprintf (promptStr + strlen(promptStr), " %d (min)", status.pos);
                        } else {
                            sprintf (promptStr + strlen(promptStr), " %d", status.pos);
                        }
                    }
                } else {
                    promptStr[0] = 0;
                }
                msg ("%s> ", promptStr);
            }

            // wait for input
            haveInput = false;
            if (!haveInput) {
                if (fgets (input, 4096, stdin) == 0)
                    return;
                input [strlen(input) - 1] = 0;        // throw out the terminating NewLine character
            }

            if (input[0] == 0)
                continue;

            ptr = input;
        }

        ptr = parseWords (ptr, &numWords, word);
        haveMore = (*ptr != 0);

        if (numWords == 0)
            continue;

        cmdName = word[0];

        // find cmd
        thisCmd = findCmd(cmdName);

        // check for valid command
        if (thisCmd == 0)
            continue;

        // If connected to the correct level of resource,
        //  Then execute the command
        if (checkCmd(thisCmd))  {
            if (!(thisCmd->func)(numWords, word))
                printHelpMsg(thisCmd);
        }
    }
}



                ////////////////////////////////
                //     Utility Functions      //
                ////////////////////////////////

void msg (const char *str, ...)
{
    va_list ap;
    char    buffer[512];

    va_start (ap, str);
    _vsnprintf (buffer, sizeof (buffer), str, ap);
    va_end (ap);

    printf (buffer);
}


void errMsg (const char *str, ...)
{
    va_list ap;
    char    buffer[256];

    va_start (ap, str);
    _vsnprintf (buffer, sizeof (buffer), str, ap);
    va_end (ap);

    printf (buffer);
}


bool checkCmd (cmdList_t *cmd)
{
    if ((cmd->resourceLevel > 0) && (gDirName[0] == 0)) {
        errMsg ("must restart; don't have a director name \n");
        return false;
    }
    if ((cmd->resourceLevel > 0) && (gPlrHand == 0)) {
        errMsg ("not connected to a director; use \"Open\" command \n");
        return false;
    }
    if ((cmd->resourceLevel > 1) && (gPlrName[0] == 0)) {
        errMsg ("must first connect to a player (use \"Close\", then \"Open\" commands)\n");
        return false;
    }

    return true;
}


cmdList_t *findCmd (char *cmdName)
{
    // find cmd
    cmdList_t *thisCmd = 0;
    cmdList_t *cmd = cmdList;
    char ambigMsg[256];
    int cmdLen = strlen(cmdName);
    bool ambiguous = false;

    while (cmd->func) {
        // first try partial match
        if (strnicmp (cmdName, cmd->name, cmdLen) == 0) {
            // check for exact match
            if (stricmp (cmdName, cmd->name) == 0) {
                thisCmd = cmd;
                ambiguous = false;
                break;
            }
            if (thisCmd && !ambiguous) {
                ambiguous = true;
                sprintf (ambigMsg, "ambiguous command: %s\n", cmdName);
                strcat(ambigMsg, "possibilities are:\n\t");
                strcat(ambigMsg, thisCmd->name);
                strcat(ambigMsg,"\n");
            }
            thisCmd = cmd;
            if (ambiguous) {
                strcat(ambigMsg, "\t");
                strcat(ambigMsg, cmd->name);
                strcat(ambigMsg, "\n");
                if (strlen(ambigMsg) > (sizeof(ambigMsg) - 25))  {
                    errMsg("too much ambiguity -- some choices omitted\n");
                    break;
                }
            }
        }
        cmd++;
    }

    if (thisCmd == 0)
        errMsg ("unrecognized command: %s\n", cmdName);

    if (ambiguous) {
        errMsg (ambigMsg);
        thisCmd = 0;
    }

    return thisCmd;
}

/*
Escape --
set false if (") or (;) or ( )
set true if (\)
if true -- causes special characters to be treated as normal characters (";\ 
*/

// parse input string str into words, return remainder of string
char *parseWords (char *str, int *numWords, char word[MAX_WORDS][FUNC_WORDSIZE])
{
    bool endNow = false;
    bool inQuote = false;
    bool escape = false;
    char *ptrDst;

    *numWords = 0;
    ptrDst = word[*numWords];
    while (*str && !endNow && (*numWords < MAX_WORDS)) {
        bool newEscape = false;
        bool copyChar = true;

        switch (*str) {
        case '#':       // ignore anything on the line after this
            if (!inQuote && !escape) {
                copyChar = false;
                *str = 0;
            }
            break;
        case ' ':       // terminator for this word
            if (!inQuote && !escape) {
                copyChar = false;
                str++;
            }
            break;

        case '"':       // a double quote (as in ")  -- toggle inQuote state
                    // needed so that you can create a clip that has a space in the name
            if (!escape) {
                inQuote = !inQuote;
                copyChar = false;
                str++;
            }
            break;
        case '\\':
                    // needed so that you can create a clip that has a doubleQuote in the name
                    //  You would do it as   harry\"Sam  -- or   "one two"\""three four"\"
                    //  Ditto for clip names with a # in them.
                    //   Must quote the \ if you need it as a regular character.
            if (!inQuote) {
                newEscape = true;
                copyChar = false;
                str++;
            }
            break;
        }

        if (copyChar)
            *ptrDst++ = *str++;

        escape = newEscape;  // "escape" only last until next character

        // IF we are not in the middle of some escape sequence
        //  AND IF we didn't copy the last character (implying ???)
        //  AND IF something was stored into this word
        //
        // THEN -- terminate this word and setup to start the next word.
        if (((!copyChar && !escape) || (*str == 0)) &&
            (ptrDst != word[*numWords])){
            // end this word
            *ptrDst = 0;
            ptrDst = word[++(*numWords)];
        }
    }

    if (*str && !endNow) {
        errMsg ("input line has too many words\n");
        // advance past extra words
        while (*str) {
            if (*str == ';') {
                str++;
                break;
            }
            str++;
        }
    }

    return str;
}



const char *mediaTypeToString (OmMediaType type)
{
    switch (type) {
    case omMediaUnknown:
        return "unknown";
    case omMediaMpegVideo:
        return "MPEG";
    case omMediaMpegStdAudio:
        return "MPEG-aud";
    case omMediaMpegAc3:
        return "MPEG-AC3";
    case omMediaPcmAudio:
        return "audio";
    case omMediaDvVideo:
        return "DV";
    case omMediaDvAudio:
        return "DV-aud";
    case omMediaRec601Video:
        return "601";
    case omMediaHdcam:
        return "HDCAM";
    case omMediaVbi:
        return "VBI";
    case omMediaData:
        return "DATA";
    default:
        return "???";
    }
}


// ***** NOT multi thread safe ****
const char *mediaSummaryToString (const OmMediaSummary *ms)
{
    static char retStr[32];

    switch (ms->type) {
    case omMediaUnknown:
        return "unknown";

    case omMediaMpegVideo:     // standard, IEC-13818 video
        return "mpeg";

    case omMediaMpegStdAudio:  // standard, IEC-13818 audio (not AAC)
        sprintf (retStr, "mpgAud(%d)", ms->channels);
        return retStr;

    case omMediaMpegAc3:       // Dolby AC3 audio in an MTS
        sprintf (retStr, "mpgAc3(%d)", ms->channels);
        return retStr;

    case omMediaPcmAudio:      // PCM audio all by itself
        sprintf (retStr, "audio(%d)", ms->channels);
        return retStr;

    case omMediaDvVideo:       // standard DV video
        if (ms->bitrate < 30000000)
            return "DV25";
        else
            return "DV50";

    case omMediaDvAudio:       // audio embedded in a DV stream
        sprintf (retStr, "DVaud(%d)", ms->channels);
        return retStr;

    case omMediaRec601Video:   // standard SMPTE Rec 601 video
        sprintf (retStr, "%db601", ms->bitsPerUnit);
        return retStr;

    case omMediaHdcam:
        return "hdcam";

    case omMediaDnxhd:
        return "dnxhd";

    case omMediaVbi:
        return "vbi";

    case omMediaData:
        return "data";
    }

    return "";
}


char *stateStr (OmPlrState state)
{
    switch (state) {
    case omPlrStateStopped:
        return ("stop");

    case omPlrStateCuePlay:
        return ("cue play");

    case omPlrStateCueRecord:
        return ("cue recd");

    case omPlrStatePlay:
        return ("play");

    case omPlrStateRecord:
        return ("record");
    }

    static char s[25];
    sprintf(s, "? (%d)", state);
    return s;
}


//////////////// file system functions /////////////////

void printHelpMsg(cmdList_t *cmd)
{
    msg("usage:\n");
    while (1) {
        if (stricmp (cmd->help, "hide") == 0)
            break;

        msg ("%s %s\n", cmd->name, cmd->help);
        if (cmd->func == (cmd + 1)->func)
            cmd++;
        else
            break;
    }
}


/*
 utility to show the error code PLUS the string 
 NOTE: simple for this simple tester -- not thread safe
*/
const char *showError(OmPlrError error)
{
    static char errString[256];

    gError = error;     // remember error code
    sprintf(errString, "%s (%#04x, %d)", 
        OmPlrGetErrorString(error), error, error - PLAYER_ERROR_BASE);
    return(errString);
}    

    // If user types 0x.... -- take that to be a handle!!  rather than a clip number
bool mapClipIndexToHandle(char * pAsciiNumber, OmPlrClipHandle *pClipHandle, int *pClipIndex) 
{
    OmPlrError  error;
    int             clipIndex;
    uint          numClips;
    OmPlrClipHandle clipHandle;

    clipIndex = strtol (pAsciiNumber, 0, 0);
    // NOTE: "strtol" is able to accept hex arguments in the form 0x....
    if ((pAsciiNumber[1] == 'X') || (pAsciiNumber[1] == 'x'))  {
        // have a handle instead of a clip number
        clipHandle = (OmPlrClipHandle) clipIndex;
        clipIndex = -1;
    } else {
        if (clipIndex < 0)  {
            errMsg("clip number can't be negative\n");
            return false;
        }

        error = OmPlrGetNumClips (gPlrHand, &numClips);
        if (error) {
            errMsg("failed to get number of attached clips on player %s   %s\n",
                    gPlrName, showError (error));
            return false;
        }

        if ((uint)clipIndex >= numClips) {
            errMsg("invalid clip number #%d on player %s\n", clipIndex, gPlrName);
            return false;
        }

        error = OmPlrGetClipAtNum (gPlrHand, (uint)clipIndex, &clipHandle);
        if (error) {
            errMsg("failed to get handle for clip #%d   %s\n",
                    clipIndex, showError (error));
            return false;
        }
    }

    if (pClipHandle)
        *pClipHandle = clipHandle;
    if (pClipIndex)
        *pClipIndex = clipIndex;
    return(true);
}    

// arg should be "-" or "A" or "+"
bool mapArgToShift(char *pArg, OmPlrShiftMode *pShift)
{
    OmPlrShiftMode shift;

    switch (*pArg) {
        case '-':
            shift = omPlrShiftModeBefore;
            break;
        case '+':
            shift = omPlrShiftModeAfter;
            break;
        case 'A':
        case 'a':
            shift = omPlrShiftModeAuto;
            break;
        case 'X':
        case 'x':
            shift = omPlrShiftModeOthers;       // new with 1.2!
            break;
        default:
            return(false);
            
    }
    if (pShift != 0)
        *pShift = shift;
    return(true);
}    


const char *printShift(OmPlrShiftMode shift)
{
    char * pStr;

    switch (shift) {
        case omPlrShiftModeBefore:
            pStr = "shift before";
            break;
        case omPlrShiftModeAfter:
            pStr = "shift after";
            break;
        case omPlrShiftModeAuto:
            pStr = "shift auto";
            break;
        case omPlrShiftModeOthers:
            pStr = "shift others";
            break;
        default:
            pStr = "unknown shift mode";
    }
    return(pStr);
}    


        // convert the APP enumeration into a string.
const char *printApp(OmPlrApp playerApp)
{
    char * pStr;

    switch (playerApp) {
    case omPlrAppLouth:
        pStr =  "VDCP";
        break;
    case omPlrAppOmnibus:
        pStr =  "Omni";
        break;
    case omPlrAppNone:
        pStr =  "local";
        break;
    case omPlrAppBvw:
        pStr =  "BVW";
        break;
    default:
        pStr =  "?????";
    }
    return(pStr);
}    




// Only used on startup of the program.
// Passed the command line arguments.
// Open up a connection to a director and maybe select a player
bool director(FUNC_ARGS)
{
    OmPlrHandle newPlrHand;
    OmPlrError  error;
    char        *newPlrName;

    if (numWords == 1) {
        if (gDirName[0] == 0) msg("no director selected\n");
        else msg("selected director is %s\n", gDirName);
        return true;
    }

    // select the director
    // select the player
    strcpy(gDirName, word[1]);      // in any case.
    newPlrName = (numWords > 2) ? word[2] : 0;

    gPlrName[0] = 0;
    gPlrHand = 0;

    error = OmPlrOpen(gDirName, newPlrName, &newPlrHand);
    if (error) {
        errMsg("failed to connect to director \"%s\" & player \"%s\"\n", 
               gDirName, 
               newPlrName);
        return true;
    }

    gPlrHand = newPlrHand;
    strcpy(gPlrName, newPlrName);
    msg("On start of program, connected to director \"%s\" & player \"%s\"\n", 
           gDirName, gPlrName);
    return true;
}


// program control functions
bool dummy(void) 
{ 
    errMsg("code not written for this cmd yet FIXME\n");
    return false; 
}

// wait for user to press key. Returns false if user wishes to quit
bool pauseForKeyPress(void)
{
    msg("Press Q to quit, any other key continues:");
    char c = getchar();  // fetch keypress directly
    if (c == 0 || c == 0x0E) getchar();  // clear any 2-char keypresses
    msg("\r                                                  \r");

    if (toupper(c) == 'Q' || c == 27) return false;
    else return true;
}

bool help(FUNC_ARGS)
{
    int         numLines;
    cmdList_t   *cmd;

    extern cmdList_t cmdList[];

    const char *nameStr = (numWords > 1) ? word[1] : "";
    int cmpLen = strlen (nameStr);

    msg("\n");

    numLines = 0;
    for (cmd = &cmdList[0]; cmd->func != 0; cmd++) {
        if (cmpLen != 0) {
            // skip over first part of list if given a specific target
            if(strnicmp (cmd->name, nameStr, cmpLen) == 0) {
                cmpLen = 0;  // start printing from here
            }
        }
        if (cmpLen == 0) {
            while (1) {
                // Print all lines for this "func"  - except "hide" lines
                //  "break" to circle back up to "for" to get 1st line for next func
                if (stricmp (cmd->help, "hide") == 0)
                    break;

                msg("%s %s\n", cmd->name, cmd->help);

                // PAUSE if interactive after a "page full" 
                // (line count is estimated; some help entries have embedded new lines)
                if (gInteractive && numLines++ > (gHeight * 15 / 25)) {       
                    numLines = 0;
                    if (!pauseForKeyPress()) return true;
                }
                if (cmd->func == (cmd + 1)->func)
                    cmd++;
                else
                    break;
            }
        }
    }
    return true;
}



bool lines(FUNC_ARGS)
{
    if (numWords == 1) {
        msg("window height is set at %d lines\n", gHeight);
        return true;
    }

    gHeight = strtol(word[1], 0, 0);
    msg("set window height to %d lines\n", gHeight);
    return true;
}



bool quit(FUNC_ARGS)
{
    if (gCopyHand) {
        msg("As exit program, Closing open copy handle 0x%08X\n", gCopyHand);
        OmPlrClipCopyAbort(gPlrHand, gCopyHand);
        OmPlrClipCopyFree(gPlrHand, gCopyHand);
    }
    if (gPlrHand)  {
        msg("As exit program, Closing open player handle 0x%08X\n", gPlrHand);
        OmPlrClose(gPlrHand);
    }

    exit (1);
    return true;
}

// Sleep using operating system function -- argument in milliSeconds
bool sleep(FUNC_ARGS)
{
    int delay;

    if (numWords < 2)
        return true;

    delay = strtol (word[1], 0, 0);
#ifdef WIN32
    Sleep (delay);
#else
    usleep(delay * 1000);
#endif
    return true;
}


/*  allow chaining -- if the source is the last command !!!
  (have a global/static file handle -- close it on entering source if it was open)
  NOTE: chaining will eventually overflow the stack!!!!  FIXME
*/
bool source(FUNC_ARGS)
{
    static FILE *gInFile = 0;
    static int  gLevel = 0;

    char        input[4096];
    char        *ptr;
    char        wordSource[MAX_WORDS][FUNC_WORDSIZE];
    int numWordsSource;
    cmdList_t *thisCmd;
    char *cmdName; 
    bool haveMore;

    // CLOSE out file from any higher level (if chaining)
    if (gInFile != 0)  {
        fclose (gInFile);
        gInFile = 0;
    }
    
    if (numWords < 2) {
        errMsg("usage: source fileName\n");
        return true;
    }
    
    gInFile = fopen (word[1], "r");
    if (gInFile == 0) {
        errMsg("failed to open file %s\n", word[1]);
        return true;
    }

    // Increase "gLevel" to note our presence  -- use for turning gInteractive back on.
    gLevel++; 
    gInteractive = false;
    haveMore = false;
    while (gInFile != 0) {
        // Get next line.  (exit if no more lines are available)
        if (!haveMore) {
            if (fgets (input, 4096, gInFile) == 0)
                break;
            input [strlen(input) - 1] = 0;    // throw out last character (the "newLine")
            ptr = input;
        }

        haveMore = false;
        
        // parse input into words
        ptr = parseWords (ptr, &numWordsSource, wordSource);
        haveMore = (*ptr != 0);

        if (numWordsSource == 0)
            continue;
        
        // This is a comment line if it starts with '#'
        if (wordSource[0][0] == '#')
            continue;

        cmdName = wordSource[0];

        // check for "done"
        if (stricmp (cmdName, "done") == 0)
            break;

        // find cmd
        thisCmd = findCmd(cmdName);

        if (thisCmd == 0)
            continue;

        if (!checkCmd(thisCmd))
            continue;

        // Execute the command
        //  NOTE -- if chaining to next source file, won't return until that file has been "sourced"
        (thisCmd->func)(numWordsSource, wordSource);
    }

    if (gInFile != 0)  {
        fclose (gInFile);
        gInFile = 0;
    }
    // If have chained down thru, only turn interactive back on after have unwound the chain
    if (--gLevel == 0)  {
        gInteractive = true;
    }
    return true;
}






// Prototypes for Command table
bool attach(FUNC_ARGS);

bool clipCopy(FUNC_ARGS);
bool clipCopyAbort(FUNC_ARGS);
bool clipCopyEnumerate(FUNC_ARGS);
bool clipCopyFree(FUNC_ARGS);
bool clipCopyStatus(FUNC_ARGS);
bool clipCopyGetParams(FUNC_ARGS);
bool clipDelete(FUNC_ARGS);
bool clipExist(FUNC_ARGS);
bool clipGetFirst(FUNC_ARGS);
bool clipGetInfo(FUNC_ARGS);
bool clipGetMediaName(FUNC_ARGS);
bool clipGetNext(FUNC_ARGS);
bool clipGetUserData(FUNC_ARGS);
bool clipGetUserDataAndKey(FUNC_ARGS);
bool clipGetTrackUserData(FUNC_ARGS);
bool clipGetTrackUserDataAndKey(FUNC_ARGS);
bool clipSetDefaultInOut(FUNC_ARGS);
bool clipProtect(FUNC_ARGS);
bool clipRegisterCallbacks(FUNC_ARGS);
bool clipRegisterWriteCallbacks(FUNC_ARGS);
bool clipSetUserData(FUNC_ARGS);
bool clipSetTrackUserData(FUNC_ARGS);
bool clipExtractData(FUNC_ARGS);

bool close(FUNC_ARGS);
bool cuePlay(FUNC_ARGS);
bool cueRecord(FUNC_ARGS);
bool detachOne(FUNC_ARGS);
bool detachAll(FUNC_ARGS);
bool getFsSpace(FUNC_ARGS);

bool getApp(FUNC_ARGS);
bool getAppClipDir(FUNC_ARGS);
bool getAppClipExtList(FUNC_ARGS);

bool getClipAtPos(FUNC_ARGS);
bool getClipAtNum(FUNC_ARGS);
bool getClipName(FUNC_ARGS);
bool getClipPath(FUNC_ARGS);
bool getClipData(FUNC_ARGS);
bool getFrameRate(FUNC_ARGS);

bool getDropFrame(FUNC_ARGS);
bool getErrorString(FUNC_ARGS);
bool getFirstPlayer(FUNC_ARGS);
bool getNextPlayer(FUNC_ARGS);
bool getNumClips(FUNC_ARGS);
bool getPlayerName(FUNC_ARGS);
bool getPlayerStatus(FUNC_ARGS);
bool getPosAndClip(FUNC_ARGS);
bool getPosInClip(FUNC_ARGS);
bool getPosOfClip(FUNC_ARGS);
bool getRecordTime(FUNC_ARGS);
bool getClipDir(FUNC_ARGS);
bool setClipDir(FUNC_ARGS);
bool getClipExtList(FUNC_ARGS);
bool setClipExtList(FUNC_ARGS);
bool getLoop(FUNC_ARGS);
bool setLoop(FUNC_ARGS);
bool getMax(FUNC_ARGS);
bool setMax(FUNC_ARGS);
bool getMin(FUNC_ARGS);
bool setMin(FUNC_ARGS);
bool getPos(FUNC_ARGS);
bool setPos(FUNC_ARGS);
bool getState(FUNC_ARGS);
bool gotoTimecode(FUNC_ARGS);

bool help(FUNC_ARGS);
bool lines(FUNC_ARGS);
bool listClips(FUNC_ARGS);
bool listPlayers(FUNC_ARGS);
bool clipRename(FUNC_ARGS);

bool open(FUNC_ARGS);
bool play(FUNC_ARGS);
bool playAt(FUNC_ARGS);
bool playDelay(FUNC_ARGS);
bool quit(FUNC_ARGS);
bool record(FUNC_ARGS);
bool recordAt(FUNC_ARGS);
bool recordDelay(FUNC_ARGS);

bool setClipData(FUNC_ARGS);
bool setMaxPosMax(FUNC_ARGS);
bool setMinMaxPosToClip(FUNC_ARGS);
bool setMinPosMin(FUNC_ARGS);
bool getRate(FUNC_ARGS);
bool getPlayEnabled(FUNC_ARGS);
bool getRecordEnabled(FUNC_ARGS);

bool getTcgInsertion(FUNC_ARGS);
bool getTcgMode(FUNC_ARGS);
bool setTcgInsertion(FUNC_ARGS);
bool setTcgMode(FUNC_ARGS);
bool setTcgData(FUNC_ARGS);

bool noop(FUNC_ARGS);

bool setRetryOpen(FUNC_ARGS);
bool sleep(FUNC_ARGS);
bool source(FUNC_ARGS);
bool step(FUNC_ARGS);
bool stop(FUNC_ARGS);
bool time(FUNC_ARGS);
bool timeDate(FUNC_ARGS);

bool Example_play(FUNC_ARGS);
bool Example_record(FUNC_ARGS);
bool Example_create(FUNC_ARGS); 
bool Example_createNext(FUNC_ARGS);
bool Example_listClips(FUNC_ARGS);
bool Example_listPlayers(FUNC_ARGS);
bool Example_listAttachedClips(FUNC_ARGS);
bool Example_slam(FUNC_ARGS);
bool Example_eject(FUNC_ARGS);
bool Example_goto(FUNC_ARGS);
bool Example_load(FUNC_ARGS);
bool Example_loadNext(FUNC_ARGS);
bool Example_play(FUNC_ARGS);
bool Example_record(FUNC_ARGS);
bool Example_shuttle(FUNC_ARGS);
bool Example_step(FUNC_ARGS);
bool Example_still(FUNC_ARGS);
bool Example_stop(FUNC_ARGS);


// NOTE: commands are case insensitive -- BUT parameters such as clip name are case sensitive
//  functionName //  connect level needed //  commandName  // help line

cmdList_t cmdList[] = {
    {help, 0,                      " ", "\n----- clip file manipulation -----\n"},
    {clipCopy, 1,                  "clipCopy", "clipName copyName first length dstFirst -\n\tcopy clip from first, for length, w/ start frame in copy."},
    {clipCopy, 1,                 "clipCopyX", "hide" /* allow multiple simultaneous copy operations */},
    {clipCopyAbort, 1,             "clipCopyAbort", "{handle} - aborts current clip copy operation"},
    {clipCopyEnumerate, 1,         "clipCopyEnumerate", "- enumerate copies in progress"},
    {clipCopyFree, 1,              "clipCopyFree", "{handle} - free the copy handle created when copying started"},
    {clipCopyStatus, 1,            "clipCopyStatus", "{handle} - report status of copy operation"},
    {clipCopyGetParams, 1,         "clipCopyGetParams", "- report parameters of copy operation"},
    {clipDelete, 1,                "clipDelete", "clipName - delete a clip"},
    {clipExist, 1,                 "clipExists", "clipName - check existance of clip"},
    {getClipDir, 1,                "clipGetDirectory", "- get current clip directory path"},
    {getClipExtList, 1,            "clipGetExtList", "- get current clip extension list"},
    {clipGetFirst, 1,              "clipGetFirst", "- get name of 1st clip"},
    {getFsSpace, 1,                "clipGetFsSpace", "- print file system free and total space"},
    {clipGetInfo, 1,               "clipGetInfo", "clipName - get clip information"},
    {clipGetMediaName, 1,          "clipGetMediaName", "clipName - get media file names for this clip "},
    {clipGetNext, 1,               "clipGetNext", "- get name of next clip"},
    {clipGetUserData, 1,           "clipGetUserData", "clipName Key - get user data for key stored in clipName"},
    {clipGetUserDataAndKey, 1,     "clipGetUserDataAndKey", "clipName KeyIndex - get user data and key stored in clipName"},
    {clipGetTrackUserData, 1,      "clipGetTrackUserData", "clipName trackNum Key - for key stored on track Num in clipName"
                                    "\n\tTrk 0 is .mov. Trk 1 is first vid track. Aud tracks follow vid tracks."},
    {clipGetTrackUserDataAndKey, 1, "clipGetTrackUserDataAndKey", "clipName trackNum KeyIndex - get user data and key stored in clipName"},
    {clipRegisterCallbacks, 1,     "clipRegisterCallbacks", " {+,-}add {+,-}delete - \n\tregister callback functions for clip changes."},
    {clipRegisterWriteCallbacks, 1,"clipRegisterWriteCallbacks", " {+,-}open {+,-}close - \n\tregister callback functions for clip WRITE changes."},
    {clipRename, 1,                "clipRename", "clipName newClipName - changes a clip's name"},
    {clipSetDefaultInOut, 1,       "clipSetDefaultInOut", "clipName defaultIn defaultOut -  \n\tsets a clip's default In & out points"},
    {setClipDir, 1,                "clipSetDirectory", "clipDirectory - set clip directory path for attach/exists/..."},
    {setClipExtList, 1,            "clipSetExtList", "- set current clip extension list"},
    {clipProtect, 1,               "clipSetProtection", "clipName {-on | -off } - sets a clip's protection."},
    {clipSetUserData, 1,           "clipSetUserData", "clipName key [data] - save user data with key for clipName;"
                                   "\n\tno data clears existing; use quotes to enclose spaces in data."},
    {clipSetTrackUserData, 1,      "clipSetTrackUserData", "clipName trackNum key [data] - on trackNum with key for clipName;" },
    {clipExtractData, 1,           "clipExtractData", "clipName startFrame [frameCount] - extract timecode from clipName." },
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- player manipulation -----\n"},
    {cuePlay, 2,                   "cuePlay", "[rate] - sets player state to cuePlay"},
    {cueRecord, 2,                 "cueRecord", "- sets player state to cueRecord"},
    {getPlayerStatus, 2,           "getPlayerStatus", " - display status of current player <s>"},
    {getPlayerStatus, 2,           "s", "hide"},
    {getPos, 2,                    "getPos", "- get current timeline position. Use getPlayerStatus instead."},
    {getPosAndClip, 2,             "getPosAndClip", "- gets current position and clip handle for timeline"},
    {getPosInClip, 2,              "getPosInClip", "- gets clip relative position within current clip on timeline"},
    {getRecordTime, 2,             "getRecordTime", "- get available recording time based on player's configuration"},
    {getState, 2,                  "getState", "- prints the player state"},
    {gotoTimecode, 2,              "gotoTimecode", " hh mm ss ff - position player at this point in current clip"},
    {time, 1,                      "getTime", "- get the player pos, house pos, reference vitc + gen/rdr"},
    {timeDate, 1,                  "getTime1", "- get the player pos, house pos, reference vitc + gen/rdr + dirDateTime"},
    {play, 2,                      "play", "[rate]  - sets player state to play"},
    {playAt, 2,                    "playAt", "sched [rate] - sets player state to play AT time"},
    {playDelay, 2,                 "playDelay", "delay [rate] - sets player state to play after delay"},
    {record, 2,                    "record", "- sets player state to record"},
    {recordAt, 2,                  "recordAt", "sched - sets player state to record AT time"},
    {recordDelay, 2,               "recordDelay", "delay - sets player state to record after delay"},
    {setPos, 2,                    "setPos", "position - set player position"},
    {step, 2,                      "step", "[frameIncrement] - step timeline"},
    {stop, 2,                      "stop", "[playerName] - stop timeline"},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- timeline manipulation -----\n"},
    {attach, 2,                    "attach", "clipName [ in out [attachBeforeClipNum [-|A|+] ]] - \n\tattach a clip to timeline"},
    {detachOne, 2,                 "detach", "clipNum [-|A|+] - eject one clip and shift the rest"},
    {detachAll, 2,                 "detachAllClips", " - eject  all clips"},
    {getClipAtNum, 2,              "getClipAtNum", "number - get handle for Nth clip on timeline (use 0 for first)"},
    {getClipAtPos, 2,              "getClipAtPos", "position - get handle for clip at specified position"},
    {getClipData, 2,               "getClipData", "clipNum - show clip points as attached to timeline"},
    {getClipName, 2,               "getClipName", "clipNum - get clip name for clip attached to timeline"},
    {getClipPath, 2,               "getClipPath", "clipNum -  \n\tget path used for attaching of a clip attached to timeline"},
    {getTcgInsertion, 2,           "GetTcgInsertion", "- get timecode insertion flags."},
    {getTcgMode, 2,                "GetTcgMode", "- get timecode generation mode."},
    {setLoop, 2,                   "Loop", "-  minPos maxPos - sets looping (set minPos = maxPos to disable)."},
    {setClipData, 2,               "setClipData", "clipNum in out [-|X|+|A] -  \n\tset clip points as attached to timeline"},
    {setMax, 2,                    "setMaxPos", "maxPosition - set maximum position of timeline"},
    {setMaxPosMax, 2,              "setMaxPosMax", " - set max position of timeline using max clip"},
    {setMinMaxPosToClip, 2,        "setMinMaxPosToClip", " clipNum - set timeline \n\tusing limits of this clip"},
    {setMin, 2,                    "setMinPos", "minPosition - set minimum position of timeline"},
    {setMinPosMin, 2,              "setMinPosMin", " - set min position of timeline using min clip"},
    {setTcgInsertion, 2,           "SetTcgInsertion", "[p] [r] - set timecode insertion flags for play, record."},
    {setTcgMode, 2,                "SetTcgMode", "{h|f|l|c} - set timecode generator mode to hold, free-run, \n"
                                    "\t or locked to timeline or locked to current clip."},
    {setTcgData, 2,                "SetTcgData", "[[hh [mm [ss [ff [df [cf [ub]]]]]]] | u ub] - set TC generator;"
                                    "\n\twhere hh,mm,ss,ff is tc, df=dropframe, cf=colorframe, ub=userbits;"
                                    "\n\t      zero will be used for parameters not supplied;"
                                    "\n\tand where \"u ub\" is \"u\" followed by userbits, to set userbits only."},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- player discovery, open/close, misc. -----\n"},
    {close, 1,                     "close", " - close connection to player and the director "},
    {getApp, 2,                    "getApp", " - get application assigned to this player"},
    {getAppClipDir, 2,             "getAppClipDirectory", "- get suggested clip directory path"},
    {getAppClipExtList, 2,         "getAppClipExtList", "- get suggested clip extension list"},
    {getDropFrame, 1,              "getDropFrame", " - get player's preference for drop frame or non drop frame"},
    {getErrorString, 0,            "getErrorString", " errorNumber - show a description of the error code"},
    {getFirstPlayer, 1,            "getFirstPlayer", "- get name of 1st player"},
    {getNextPlayer, 1,             "getNextPlayer", "- get name of next player"},
    {getPlayerName, 2,             "getPlayerName", "- gets the name of the player for this connection"},
    {open, 0,                      "open", "{directorName|IP addr|\".\"} {playerName|\"null\"} - connect to a player;"
                                        "\n\tuse current director if \".\" is specified;"
                                        "\n\tuse NULL player if \"null\" is specified"},
    {open, 0,                      "open1", "{directorName|IP addr|\".\"} {playerName|\"null\"} - connect to a player and"
                                        "\n\tregister a callback function for notification of the connection;"
                                        "\n\tuse current director if \".\" is specified;"
                                        "\n\tuse NULL player if \"null\" is specified"},
    {setRetryOpen, 1,              "setRetryOpen", "{-on | -off } - if on, will try to re-open a failed connection"},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- redundant functions that get player status -----\n"},
    {getFrameRate, 1,              "getFrameRate", "- get player's frame rate (24, 25, 29.97, etc.)"},
    {getLoop, 2,                   "getLoop", "- get loop status. Use getPlayerStatus instead."},
    {getMax, 2,                    "getMaxPos", "- get maximum timeline position. Use getPlayerStatus instead."},
    {getMin, 2,                    "getMinPos", "- get minimum timeline position. Use getPlayerStatus instead."},
    {getNumClips, 2,               "getNumClips", "- gets the number of clips attached to timeline"},
    {getPosOfClip, 2,              "getPosOfClip", "clipNum - gets clip position on timeline."},
    {getRate, 2,                   "getRate", "- Get player's frame rate. Use getPlayerStatus instead."},
    {getPlayEnabled, 2,            "playEnabled", "- Get player's play-enabled flag. Use getPlayerStatus instead."},
    {getRecordEnabled, 2,          "RecordEnabled", "- Get player's record-enabled flag. Use getPlayerStatus instead."},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- redundant functions that get clip info -----\n"},
    {clipGetInfo, 1,               "clipGetDefaultInOut", "clipName - gets in & out points. Use clipGetInfo instead."},
    {clipGetInfo, 1,               "clipGetProtection", "clipName - gets protection flag. Use clipGetInfo instead."},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- \"convenience\" functions: VTR-like controls -----\n"},
    {Example_slam, 2,              "XBot", "- stop motion; go to Min timeline position"},
    {Example_create, 2,            "Xcreate", "clipName [in out] - \n\tEject all and then create this clip <XC>"},
    {Example_create, 2,            "xc", "hide"},
    {Example_createNext, 2,        "XcreateNext", "clipName [in out] - \n\tAppend this clip to end of timeline"},
    {Example_eject, 2,             "Xeject", "- stop motion; detach all clips"},
    {Example_goto, 2,              "Xgoto", " [clipNum] position - goto a position in a clip & pause "},
    {Example_load, 2,              "Xload", "clipName [in out] - \n\tEject all and then load this clip <XL>"},
    {Example_load, 2,              "xl", "hide"},
    {Example_loadNext, 2,          "XloadNext", "clipName [in out] - \n\tAppend this clip to end of timeline"},
    {Example_play, 2,              "Xplay", "[rate] [clipName] - Load if needed, then play the clip"},
    {Example_record, 2,            "Xrecord", "[clipName [numFrames ] - record a clip"},
    {Example_shuttle, 2,           "Xshuttle", "[rate] - play at variable speed"},
    {Example_step, 2,              "Xstep", " [stepSizeSign] - move X frames from current position"},
    {Example_still, 2,             "Xstill", "- show still frame"},
    {Example_stop, 2,              "Xstop", "- stop motion; show input <XS>"},
    {Example_stop, 2,              "Xs", "hide"},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- \"convenience\" functions: information -----\n"},
    {Example_listAttachedClips, 2, "XlistAttached", " - list all clips attached to timeline <lt>"},
    {Example_listAttachedClips, 2, "lt", "hide"},
    {Example_listClips, 1,         "XlistClips", " - list all clips in current directory <lc>"},
    {Example_listClips, 1,         "lc", "hide"},
    {Example_listPlayers, 1,       "XlistPlayers", " - list all players on current director <lp>"},
    {Example_listPlayers, 1,       "lp", "hide"},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- other (administrative) commands -----\n"},
    {help, 0,                      "help", "[cmd] - shows help. If cmd given, shows help for matching commands. <h>"},
    {lines, 0,                     "lines", "numLines - set the screen height used to pause listings."},
    {sleep, 0,                     "sleep", "milliSeconds - sleep"},
    {source, 0,                    "source", "fileName - read commands from fileName"},
    {quit, 0,                      "quit", "- quits the session <exit>"},
    {quit, 0,                      "exit", "hide"},
    {help, 0,                      " ", " "},       // spacer

    {help, 0,                      " ", "----- syntax, parameters, and tips -----\n"},
    {help, 0,                      " ", "command - description           command has no parameters."},
    {help, 0,                      " ", "command param - description     parameter is required."},
    {help, 0,                      " ", "command {A|B} - description     parameter A OR B required."},
    {help, 0,                      " ", "command [param] - description   parameter is optional."},
    {help, 0,                      " ", "command - description <cmd>     \"cmd\" is a shortcut for command."},
    {help, 0,                      " ", " "},
    {help, 0,                      " ", "clipNum - a decimal index (i.e. 4) or a hexadecimal handle (i.e. 0x4b32a)."},
    {help, 0,                      " ", "{-|A|+|X} - timeline adjustments when attaching, detaching, or changing clips:"},
    {help, 0,                      " ", "          - to move earlier clips to make room or fill space,"},
    {help, 0,                      " ", "          + to move later clips to make room or fill space,"},
    {help, 0,                      " ", "          X to move earlier and/or later clips but not \"this\" clip."},
    {help, 0,                      " ", "          A to move clips automatically so current position is undisturbed."},
    {help, 0,                      " ", "in, out, position - position in frames, either in clip or in timeline. "},
    {help, 0,                      " ", "hh, mm, ss, ff - timecode hours, minutes, seconds, frames. "},
    {help, 0,                      " ", "df, cf - dropframe & colorframe flags; 1 to set, 0 to clear. "},
    {help, 0,                      " ", "ub - user bits, either in decimal or hex (i.e., 0x11223344)."},
    {help, 0,                      " ", " "},
    {help, 0,                      " ", "Commands are not case-sensitive. Unambiguous partial commands can be used."},
    {NULL, 0,                      " ", " "}       // END marker -- NULL function pointer
    
};


/*
idea -- a "What's Wrong" function -- when the picture isn't moving

check: 
clip loaded?
play enabled?
max set to more than min?
where is current pos?
Is it outside of clip first/last?


Can't check --
mediaPort attached?
right kind of media for attached port?
*/
 
