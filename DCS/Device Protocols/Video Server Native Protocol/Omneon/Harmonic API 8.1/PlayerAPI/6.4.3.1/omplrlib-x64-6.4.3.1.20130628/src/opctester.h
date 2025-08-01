
#ifdef _MSC_VER
#pragma warning( disable : 4786 )
#endif

#include "string"       // for stricmp, sscanf, strlen, memset, ...
using namespace std;

#include "omplrclnt.h"     // uses "bool"

#ifndef WIN32
#define stricmp strcasecmp
#define strnicmp strncasecmp
#define _vsnprintf vsnprintf
#else
#if _MSC_VER >= 1600
#define stricmp _stricmp
#define strnicmp _strnicmp
#endif
#endif


#define TESTER_VERSION_STR "TOT.0.27 11mar05"

// number of ClipCopyHandles we'll enumerate
#define COPY_HANDLES 50

//amount of user data we'll get or set
#define USER_DATA_SIZE 256

#ifndef LOCAL
#define PRIVATE static
#define LOCAL static
#endif
  
#define MAX_WORDS 32
#define FUNC_WORDSIZE 512
#define FUNC_ARGS int numWords, char word[][FUNC_WORDSIZE]

extern char gDirName[];
extern char gPlrName[];
extern char gClipDirectoryName[];       // needed for clip callbacks
extern char gClipExtensionList[];       // needed for clip callbacks
extern OmPlrHandle gPlrHand;
extern OmPlrClipCopyHandle gCopyHand;
extern OmPlrError gError;

extern int  gHeight;
extern bool gInteractive;



typedef struct {
    bool    (*func)(FUNC_ARGS);
    int   resourceLevel;
    char    name[32];
    char    help[500];
} cmdList_t;


bool checkCmd (cmdList_t *cmd);
bool dummy(void);
bool pauseForKeyPress(void);
void errMsg (const char *str, ...);
cmdList_t *findCmd (char *cmdName);
void msg (const char *str, ...);
char *parseWords (char *str, int *numWords, char word[MAX_WORDS][FUNC_WORDSIZE]);
char *stateStr (OmPlrState state);

const char *showError(OmPlrError error);
bool mapClipIndexToHandle(char * pAsciiNumber, OmPlrClipHandle *pClipHandle, int *pClipIndex);
bool mapArgToShift(char *pArg, OmPlrShiftMode *pShift);
const char *printShift(OmPlrShiftMode shift);
const char *printApp(OmPlrApp playerApp);

// Utility functions only used by SAMPLE code
//void printClipList (int OmPlrHand, char *OmPlrName, bool fullPath);
const char *mediaSummaryToString (const OmMediaSummary *ms);
const char *mediaTypeToString (OmMediaType type);
