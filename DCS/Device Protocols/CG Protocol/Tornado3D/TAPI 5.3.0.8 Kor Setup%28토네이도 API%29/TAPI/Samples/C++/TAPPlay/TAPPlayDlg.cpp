// TAPPlayDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TAPPlay.h"
#include "TAPPlayDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CTAPPlayDlg dialog


CTAPPlayDlg::CTAPPlayDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTAPPlayDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CTAPPlayDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_MESSAGE, MessageEdit);
}

BEGIN_MESSAGE_MAP(CTAPPlayDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BROWSE, &CTAPPlayDlg::OnBnClickedBrowse)
	ON_BN_CLICKED(IDC_LOAD, &CTAPPlayDlg::OnBnClickedLoad)
	ON_BN_CLICKED(IDC_PREPARE, &CTAPPlayDlg::OnBnClickedPrepare)
	ON_BN_CLICKED(IDC_PLAY, &CTAPPlayDlg::OnBnClickedPlay)
	ON_BN_CLICKED(IDC_CLEAR, &CTAPPlayDlg::OnBnClickedClear)
	ON_BN_CLICKED(IDC_CONNECT, &CTAPPlayDlg::OnBnClickedConnect)
END_MESSAGE_MAP()


// CTAPPlayDlg message handlers

BOOL CTAPPlayDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	GetDlgItem(IDC_IP)->SetWindowText(_T("127.0.0.1"));
	GetDlgItem(IDC_PORT)->SetWindowText(_T("30002"));
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CTAPPlayDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CTAPPlayDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CTAPPlayDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CTAPPlayDlg::OnBnClickedConnect()
{
	CString strIPAddress, strPort;
	GetDlgItem(IDC_IP)->GetWindowText(strIPAddress);
	GetDlgItem(IDC_PORT)->GetWindowText(strPort);
	int Port = _ttoi(strPort);
	theApp.pTAP->Connect(TRUE, strIPAddress.AllocSysString(), Port, 1000, theApp.pMyHandler);
}


void CTAPPlayDlg::OnBnClickedBrowse()
{
	CString strFilter = _T("Cut File (*.tcf)|*.tcf|All files (*.*)|*.*||");

	CFileDialog FileDialog(TRUE, _T("tcf"), NULL, OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER, strFilter);
	if(FileDialog.DoModal() != IDOK)
		return;

	GetDlgItem(IDC_TCF_FILENAME)->SetWindowText(FileDialog.GetPathName());
	GetDlgItem(IDC_PAGE_NAME)->SetWindowText(FileDialog.GetFileTitle());

	UpdateData(FALSE);
}

void CTAPPlayDlg::OnBnClickedLoad()
{
	CString TCFFileName, PageName;
	GetDlgItem(IDC_TCF_FILENAME)->GetWindowText(TCFFileName);
	GetDlgItem(IDC_PAGE_NAME)->GetWindowText(PageName);
	bstr_t str = TCFFileName.AllocSysString();
	theApp.pTAP->LoadPage(str, PageName.AllocSysString());
	::SysFreeString(str);
}

void CTAPPlayDlg::OnBnClickedPrepare()
{
	CString PageName;
	GetDlgItem(IDC_PAGE_NAME)->GetWindowText(PageName);
	bstr_t str = PageName.AllocSysString();
	theApp.pTAP->PreparePage(str, TAPI::LAYER_SECTION_0, TRUE);
	::SysFreeString(str);
}

void CTAPPlayDlg::OnBnClickedPlay()
{
	theApp.pTAP->Play(TAPI::LAYER_SECTION_0);
}

void CTAPPlayDlg::OnBnClickedClear()
{
	theApp.pTAP->Stop();
}

void CTAPPlayDlg::ShowMessage(CString& strRecv){
	CString str = strRecv;
	str += _T("\r\n");

	MessageEdit.ReplaceSel(str);
}

void CTAPPlayDlg::OnReceive(CString& strRecv){ // Receive Network Data.

	ShowMessage(strRecv);

	if(!MessageEdit.m_hWnd)
		return;

	bstr_t str = strRecv.AllocSysString();
	if(!theApp.pTAPParser->Parse(str)){
		::SysFreeString(str);
		return;
	}

	::SysFreeString(str);

	TAPI::eTAPCommand command = theApp.pTAPParser->GetCommand();
	switch(command){
	case TAPI::TAP_COMMAND_Hello_Connected:
		{
		}
		break;
	case TAPI::TAP_COMMAND_Load:
		{
			CString PageName = theApp.pTAPParser->GetNextString();
			theApp.pTAP->QueryAliasAll(PageName.AllocSysString());
		}
		break;
	case TAPI::TAP_COMMAND_Query:
		{
			CString strWord;
			TAPI::eTAPCommand command2 = theApp.pTAPParser->GetNextCommand();
			switch(command2){
			case TAPI::TAP_COMMAND_Load:// SUCCESS QUERY LOAD   : 페이지명들 전체 날라옴.
				{
				}
				break;
			case TAPI::TAP_COMMAND_Page: // SUCCESS QUERY PAGE
				{
				}
				break;
			case TAPI::TAP_COMMAND_ObjValue: // SUCCESS QUERY OBJVALUE 발견 (객체값 쿼리시)
				{
				}
				break;
			case TAPI::TAP_COMMAND_ObjAttr: // SUCCESS QUERY OBJATTR 발견 (객체속성 쿼리시)
				{

				}
				break;
			case TAPI::TAP_COMMAND_ScrollMargin:
				{
				}
				break;
			case TAPI::TAP_COMMAND_AliasAll:
				{
					 CString PageName = theApp.pTAPParser->GetNextQuotationString();
				}	
				break;
			default:
				break;
			}
		}
		break;
	default:
		break;
	}

}
