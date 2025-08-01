// TAPAnimation.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "TAPAnimation.h"
#include "TAPAnimationDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


//////////////////////////////////////////////////////////////////////////

HRESULT STDMETHODCALLTYPE CMyTAPHandler::raw_Test(){
	AfxMessageBox(_T("Test Hello"));
	return S_OK;
};

HRESULT STDMETHODCALLTYPE CMyTAPHandler::raw_OnConnect(){
	AfxMessageBox(_T("raw_OnConnect"));
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CMyTAPHandler::raw_OnClose(){
	AfxMessageBox(_T("raw_OnClose"));
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CMyTAPHandler::raw_OnReceive(const BSTR pData){
//HRESULT STDMETHODCALLTYPE CMyTAPHandler::raw_OnReceive(BSTR pData){
	CString strReceive = LPCTSTR(pData);
	//if(!pParent)
	//	return S_FALSE;

	//((CTAPPlayDlg*)pParent)->OnReceive(strReceive);
	if(!theApp.m_pMainWnd)
		return S_FALSE;

	theApp.OnReceive(strReceive);

	return S_OK;
}
//////////////////////////////////////////////////////////////////////////

// CTAPAnimationApp

BEGIN_MESSAGE_MAP(CTAPAnimationApp, CWinApp)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()


// CTAPAnimationApp construction

CTAPAnimationApp::CTAPAnimationApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CTAPAnimationApp object

CTAPAnimationApp theApp;


// CTAPAnimationApp initialization

BOOL CTAPAnimationApp::InitInstance()
{
	// InitCommonControlsEx() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// Set this to include all the common control classes you want to use
	// in your application.
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();

	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization
	SetRegistryKey(_T("Visual Research Inc"));
	
	// Create a T3D Engine Instance
	CoInitialize(0);
	
	pTAP.CreateInstance(__uuidof(TAPI::TAP));
	pTAPParser.CreateInstance(__uuidof(TAPI::TAPParser));

	//pMyHandler.CreateInstance(__uuidof(TAPI::TAPEventHandler));
	pMyHandler = new CMyTAPHandler;


	CTAPAnimationDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	pTAP->Destroy();
	//delete pMyHandler;
	pMyHandler->Release();

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}

void CTAPAnimationApp::OnReceive(CString& strRecv){
	((CTAPAnimationDlg*)m_pMainWnd)->OnReceive(strRecv);
}