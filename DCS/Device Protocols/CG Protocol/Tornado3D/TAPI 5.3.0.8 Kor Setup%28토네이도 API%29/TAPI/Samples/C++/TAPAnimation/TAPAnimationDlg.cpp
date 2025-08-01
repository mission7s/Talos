// TAPAnimationDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TAPAnimation.h"
#include "TAPAnimationDlg.h"

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


// CTAPAnimationDlg dialog




CTAPAnimationDlg::CTAPAnimationDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTAPAnimationDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CTAPAnimationDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_MESSAGE, MessageEdit);

	DDX_Text(pDX, IDC_BS_X, BeginScales[0]);
	DDX_Text(pDX, IDC_BS_Y, BeginScales[1]);
	DDX_Text(pDX, IDC_BS_Z, BeginScales[2]);
	DDX_Text(pDX, IDC_ES_X, EndScales[0]);
	DDX_Text(pDX, IDC_ES_Y, EndScales[1]);
	DDX_Text(pDX, IDC_ES_Z, EndScales[2]);

	DDX_Text(pDX, IDC_BF_1, BeginFrames[0]);
	DDX_Text(pDX, IDC_BF_2, BeginFrames[1]);
	DDX_Text(pDX, IDC_BF_3, BeginFrames[2]);
	DDX_Text(pDX, IDC_BF_4, BeginFrames[3]);
	DDX_Text(pDX, IDC_BF_5, BeginFrames[4]);
	DDX_Text(pDX, IDC_EF_1, EndFrames[0]);
	DDX_Text(pDX, IDC_EF_2, EndFrames[1]);
	DDX_Text(pDX, IDC_EF_3, EndFrames[2]);
	DDX_Text(pDX, IDC_EF_4, EndFrames[3]);
	DDX_Text(pDX, IDC_EF_5, EndFrames[4]);
	DDX_Text(pDX, IDC_BD_1, BeginDegrees[0]);
	DDX_Text(pDX, IDC_BD_2, BeginDegrees[1]);
	DDX_Text(pDX, IDC_BD_3, BeginDegrees[2]);
	DDX_Text(pDX, IDC_BD_4, BeginDegrees[3]);
	DDX_Text(pDX, IDC_BD_5, BeginDegrees[4]);
	DDX_Text(pDX, IDC_ED_1, EndDegrees[0]);
	DDX_Text(pDX, IDC_ED_2, EndDegrees[1]);
	DDX_Text(pDX, IDC_ED_3, EndDegrees[2]);
	DDX_Text(pDX, IDC_ED_4, EndDegrees[3]);
	DDX_Text(pDX, IDC_ED_5, EndDegrees[4]);
}

BEGIN_MESSAGE_MAP(CTAPAnimationDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_CONNECT, &CTAPAnimationDlg::OnBnClickedConnect)
	ON_BN_CLICKED(IDC_BROWSE1, &CTAPAnimationDlg::OnBnClickedBrowse1)
	ON_BN_CLICKED(IDC_SET_SCALE, &CTAPAnimationDlg::OnBnClickedSetScale)
	ON_BN_CLICKED(IDC_PREPARE1, &CTAPAnimationDlg::OnBnClickedPrepare1)
	ON_BN_CLICKED(IDC_PLAY1, &CTAPAnimationDlg::OnBnClickedPlay1)
	ON_BN_CLICKED(IDC_CLEAR1, &CTAPAnimationDlg::OnBnClickedClear1)
	ON_BN_CLICKED(IDC_BROWSE2, &CTAPAnimationDlg::OnBnClickedBrowse2)
	ON_BN_CLICKED(IDC_SET_CIRCLEANGLE_1, &CTAPAnimationDlg::OnBnClickedSetCircleangle1)
	ON_BN_CLICKED(IDC_SET_CIRCLEANGLE_2, &CTAPAnimationDlg::OnBnClickedSetCircleangle2)
	ON_BN_CLICKED(IDC_SET_CIRCLEANGLE_3, &CTAPAnimationDlg::OnBnClickedSetCircleangle3)
	ON_BN_CLICKED(IDC_SET_CIRCLEANGLE_4, &CTAPAnimationDlg::OnBnClickedSetCircleangle4)
	ON_BN_CLICKED(IDC_SET_CIRCLEANGLE_5, &CTAPAnimationDlg::OnBnClickedSetCircleangle5)
	ON_BN_CLICKED(IDC_PREPARE2, &CTAPAnimationDlg::OnBnClickedPrepare2)
	ON_BN_CLICKED(IDC_PLAY2, &CTAPAnimationDlg::OnBnClickedPlay2)
	ON_BN_CLICKED(IDC_CLEAR2, &CTAPAnimationDlg::OnBnClickedClear2)
END_MESSAGE_MAP()


// CTAPAnimationDlg message handlers

BOOL CTAPAnimationDlg::OnInitDialog()
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

	BeginScales[0] = 0;		EndScales[0] = 80;		// x
	BeginScales[1] = 100;	EndScales[1] = 100;		// y
	BeginScales[2] = 100;	EndScales[2] = 100;		// z

	for(int i=0; i<5; i++){
		BeginFrames[i] = i*10;
		EndFrames[i] = (i+1)*10;
		BeginDegrees[i] = i*10;
		EndDegrees[i] = (i+1)*10;
	}

	UpdateData(FALSE);
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CTAPAnimationDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CTAPAnimationDlg::OnPaint()
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
HCURSOR CTAPAnimationDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CTAPAnimationDlg::OnBnClickedConnect()
{
	CString strIPAddress, strPort;
	GetDlgItem(IDC_IP)->GetWindowText(strIPAddress);
	GetDlgItem(IDC_PORT)->GetWindowText(strPort);
	int Port = _ttoi(strPort);
	theApp.pTAP->Connect(TRUE, strIPAddress.AllocSysString(), Port, 1000, theApp.pMyHandler);
}

void CTAPAnimationDlg::OnBnClickedBrowse1()
{
	CString strFilter = _T("Cut File (*.tcf)|*.tcf|All files (*.*)|*.*||");

	CFileDialog FileDialog(TRUE, _T("tcf"), NULL, OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER, strFilter);
	if(FileDialog.DoModal() != IDOK)
		return;

	CString TcfFileName = FileDialog.GetPathName();
	PageNames[0] = FileDialog.GetFileTitle();

	theApp.pTAP->LoadPage(TcfFileName.AllocSysString(), PageNames[0].AllocSysString());

	GetDlgItem(IDC_TCF_FILENAME1)->SetWindowText(TcfFileName);
	UpdateData(FALSE);
}

void CTAPAnimationDlg::OnBnClickedSetScale()
{
	UpdateData();

	CString strSend;
	strSend.Format(_T("OBJATTR \"%s\" \"%s\" ScaleStart %d,%d,%d Scale %d,%d,%d"), 
		PageNames[0], _T("Bar"), 
		BeginScales[0], BeginScales[1], BeginScales[2],
		EndScales[0], EndScales[1], EndScales[2]);

	theApp.pTAP->Send(strSend.AllocSysString());

}

void CTAPAnimationDlg::OnBnClickedPrepare1()
{
	theApp.pTAP->PreparePage(PageNames[0].AllocSysString(), TAPI::LAYER_SECTION_0, TRUE);
}

void CTAPAnimationDlg::OnBnClickedPlay1()
{
	theApp.pTAP->Play(TAPI::LAYER_SECTION_0);
}

void CTAPAnimationDlg::OnBnClickedClear1()
{
	theApp.pTAP->Stop();
}

void CTAPAnimationDlg::OnBnClickedBrowse2()
{
	CString strFilter = _T("Cut File (*.tcf)|*.tcf|All files (*.*)|*.*||");

	CFileDialog FileDialog(TRUE, _T("tcf"), NULL, OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER, strFilter);
	if(FileDialog.DoModal() != IDOK)
		return;

	CString TcfFileName = FileDialog.GetPathName();
	PageNames[1] = FileDialog.GetFileTitle();

	theApp.pTAP->LoadPage(TcfFileName.AllocSysString(), PageNames[1].AllocSysString());

	GetDlgItem(IDC_TCF_FILENAME2)->SetWindowText(TcfFileName);
	UpdateData(FALSE);
}

void CTAPAnimationDlg::OnBnClickedSetCircleangle1()
{
	UpdateData();
	CString strSend;
	strSend.Format(_T("OBJATTR \"%s\" \"%s\" CircleAngle %d,%d,%d,%d"), 
		PageNames[1], _T("Pie1"), 
		BeginFrames[0], BeginDegrees[0], EndFrames[0], EndDegrees[0]);

	theApp.pTAP->Send(strSend.AllocSysString());
}

void CTAPAnimationDlg::OnBnClickedSetCircleangle2()
{
	UpdateData();
	CString strSend;
	strSend.Format(_T("OBJATTR \"%s\" \"%s\" CircleAngle %d,%d,%d,%d"), 
		PageNames[1], _T("Pie2"), 
		BeginFrames[1], BeginDegrees[1], EndFrames[1], EndDegrees[1]);

	theApp.pTAP->Send(strSend.AllocSysString());
}

void CTAPAnimationDlg::OnBnClickedSetCircleangle3()
{
	UpdateData();
	CString strSend;
	strSend.Format(_T("OBJATTR \"%s\" \"%s\" CircleAngle %d,%d,%d,%d"), 
		PageNames[1], _T("Pie3"), 
		BeginFrames[2], BeginDegrees[2], EndFrames[2], EndDegrees[2]);

	theApp.pTAP->Send(strSend.AllocSysString());
}

void CTAPAnimationDlg::OnBnClickedSetCircleangle4()
{
	UpdateData();
	CString strSend;
	strSend.Format(_T("OBJATTR \"%s\" \"%s\" CircleAngle %d,%d,%d,%d"), 
		PageNames[1], _T("Pie4"), 
		BeginFrames[3], BeginDegrees[3], EndFrames[3], EndDegrees[3]);

	theApp.pTAP->Send(strSend.AllocSysString());
}

void CTAPAnimationDlg::OnBnClickedSetCircleangle5()
{
	UpdateData();
	CString strSend;
	strSend.Format(_T("OBJATTR \"%s\" \"%s\" CircleAngle %d,%d,%d,%d"), 
		PageNames[1], _T("Pie5"), 
		BeginFrames[4], BeginDegrees[4], EndFrames[4], EndDegrees[4]);

	theApp.pTAP->Send(strSend.AllocSysString());
}

void CTAPAnimationDlg::OnBnClickedPrepare2()
{
	theApp.pTAP->PreparePage(PageNames[1].AllocSysString(), TAPI::LAYER_SECTION_1, TRUE);
}

void CTAPAnimationDlg::OnBnClickedPlay2()
{
	theApp.pTAP->Play(TAPI::LAYER_SECTION_1);
}

void CTAPAnimationDlg::OnBnClickedClear2()
{
	theApp.pTAP->Stop();
}

//////////////////////////////////////////////////////////////////////////

void CTAPAnimationDlg::ShowMessage(CString& strRecv){
	CString str = strRecv;
	str += _T("\r\n");

	MessageEdit.ReplaceSel(str);
}

void CTAPAnimationDlg::OnReceive(CString& strRecv){ // Receive Network Data.

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
