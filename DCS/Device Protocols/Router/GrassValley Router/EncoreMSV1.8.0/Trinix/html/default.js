// DOM helper
if (document.all) {
	var domRef = ".all";
} else {
	var domRef = ".getElementById";
}

function expandGroup(sGroup, bFinal) {
	if (parent.bSchemaLoaded == 1) {
		eval("document" + domRef + "('" + sGroup + "')" + ".style.display = ''");
		(bFinal == 0) ? swapImg(sGroup + 'Img', 'tree_minus.gif') : swapImg(sGroup + 'Img', 'tree_corner_minus.gif');
	}
}

function collapseGroup(sGroup, bFinal) {
	eval("document" + domRef + "('" + sGroup + "')" + ".style.display = 'none'");
	(bFinal == 0) ? swapImg(sGroup + 'Img','tree_plus.gif') : swapImg(sGroup + 'Img','tree_corner_plus.gif');
}

function swapImg(sImg, sSrc) {
	document.images[sImg].src = sSrc;
}

function highlightDevice(sDevice) {
	eval("document" + domRef + "('" + sDevice + "')" + ".style.background = '#006EDF'");
}

function clearHighlight(sDevice) {
	eval("document" + domRef + "('" + sDevice + "')" + ".style.background = '#323232'");
}
			
// clean up text
function cleanUpText(sInput) {
	var sOutput = '';
	// pad single quotes
	while (sInput.indexOf("'") > -1) {
		sInput = sInput.replace("'","&acute;");
	}					
	// replace carriage returns
	for (var i = 0; i < sInput.length; i++) {
		if ((sInput.charCodeAt(i) == 13) && (sInput.charCodeAt(i + 1) == 10)) {
			i++;
			sOutput += '<br>';
		} else {
			sOutput += sInput.charAt(i);
		}
	}
	return sOutput;
}

// check firmware status
function checkFirmStatus (iFpgaLoad, iFpgaSelect, iULoad, iUSelect) {
	((iFpgaLoad == '') || (iFpgaSelect == '') || (iFpgaLoad == iFpgaSelect)) ? iFpga = 1 : iFpga = 0;
	((iULoad == '') || (iUSelect == '') || (iULoad == iUSelect)) ? iUCtrl = 1 : iUCtrl = 0;
	if ((iFpga + iUCtrl) == 2) {
		sStatus = 'green'; 
		sCue = 'OK';
		iCheck += 1;
	} else {
		sStatus = 'red'; 
		sCue = 'Warning';
	}
	document.write('<img src="led_' + sStatus + '.gif" alt="' + sCue + '" width="12" height="12" hspace="0" vspace="0" border="0">');		
}
			
// secondary window
function createWin(sURL, sName, bMenubar) {
	sFeatures = 'width=640,height=480,toolbar=0,location=0,directories=0,status=0,menubar=' + bMenubar + ',scrollbars=1,resizable=1';
    newWin = window.open(sURL, sName, sFeatures);
    newWin.focus();
}

// inline clock
function elapsedTime() {
	if (sMode == 'run') {	
		if (iSecond >= 60) {
			iSecond = 0;
			++iMinute;
			if (iMinute >= 58) {
				parent.content.history.go(0);
			}
			elapsedTime()
		} else {
			++iSecond;
			iHour = iHour - 0; // convert to int if str
			if (iHour < 10) iHour = '0' + iHour;
			iMinute = iMinute - 0; // convert to int if str
			if (iMinute < 10) iMinute = '0' + iMinute;
			if (iSecond < 10) iSecond = '0' + iSecond;
			sTime = iHour + ':' + iMinute + ':' + iSecond + ' ' + dYear + '-' + dMonth + '-' + dDate;
			if (sDLS.toUpperCase() == 'CHECKED') sTime = sTime + ' DLS';
			document.timer.time.value=sTime;
			setTimeout("elapsedTime()",1000);
		}
	} else {
		document.timer.time.value=sTime;
	}		
}

// parse query string
function splitQueryString() {
  var splitArray = sQueryString.split('&');
  for (var i = 0; i < splitArray.length; i++) {
    eval('s' + (i+1) + '="' + splitArray[i] + '"');
  }
}

// Open firmware download progress window
function OpenFirmwareDownloadStatusWindow(archiveNo)
{
    if ((archiveNo == 0) || (archiveNo == 1))
    {
        newWin = window.open('LoadedPercentage_' + archiveNo + '.htm', 'statusWin', 
                             'width=500,height=500,toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1');
        newWin.focus();
    }
}
