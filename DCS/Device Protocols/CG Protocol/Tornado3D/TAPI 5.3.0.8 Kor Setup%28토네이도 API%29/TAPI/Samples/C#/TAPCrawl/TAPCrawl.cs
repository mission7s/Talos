using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace TAPCrawl
{
    public partial class TAPCrawl : Form
    {
        protected TAPI.TAP TAP;
        protected TAPI.TAPParser Parser;
        protected cMyHandler MyHandler;
        protected string TcfFileName;
        protected string PageName;
        protected string TextFileName;
        protected List<string> TextLine;
        protected int TextLineCount;
         
        public TAPCrawl()
        {
            InitializeComponent();

            // Init Attribute
            TextLineCount = 2;           
            TextLine = new List<string>();

            // Initialize TAP Component
            TAP = new TAPI.TAP();

            Parser = new TAPI.TAPParser(); // Parser parses TAP Server's message

            // Create a MyHandler instance that will receive message from the TAP Server
            try
            {
                MyHandler = new cMyHandler(this); 
            }
            catch (Exception e)
            {
                System.Windows.Forms.MessageBox.Show(e.Message);
            }
        }
                
        private void Connect_Click(object sender, EventArgs e)
        {
            // connect TAP Server
            TAP.Connect(1, ServerIP.Text, Convert.ToInt32(ServerPort.Text), 1000, MyHandler);
        }
                
        private void Browse_Click(object sender, EventArgs e)
        {
            // Open Tcf File and Set PageName
            if (openTcfFileDialog.ShowDialog() == DialogResult.OK)
            {
                TcfFileName = openTcfFileDialog.FileName;
                TcfFileNameEdit.Text = TcfFileName;
                                
                string text = openTcfFileDialog.FileName;// FilSafeFileName;
                PageName = text.Remove(text.Length - 4);                
            }
        }

        private void Load_Click(object sender, EventArgs e)
        {
            // Load TAP
            TAP.LoadPage(TcfFileNameEdit.Text, PageName);
        }

        private void Prepare_Click(object sender, EventArgs e)
        {           
            // Set first article string
            TextLine[0] = TextLine[0].Replace("###", "");
            TAP.SetText(PageName, "space1", "space");            
            TAP.SetText(PageName, "subject", TextLine[0]);            
            TAP.SetText(PageName, "space2", "space");
            TAP.SetText(PageName, "content", TextLine[1]);            
            
            // Prepare Page 
            TAP.PreparePage(PageName, TAPI.eLayer.LAYER_SECTION_0, 1);
        }

        private void Play_Click(object sender, EventArgs e)
        {
            TAP.Play(TAPI.eLayer.LAYER_SECTION_0);

            timer.Interval = 500;
            timer.Start();
        }

        private void Clear_Click(object sender, EventArgs e)
        {
            // Break off playing mode of TAP            
            TAP.Out(TAPI.eLayer.LAYER_SECTION_0);
            timer.Stop();
            TextLineCount = 2;
        }

        private void TextBrowse_Click(object sender, EventArgs e)
        {
            
            // Add article text to TextLine List
            if (openTcfFileDialog.ShowDialog() == DialogResult.OK)
            {
                TextFileName = openTcfFileDialog.FileName;
                TextFileNameEdit.Text = TextFileName;

                TextLine.Clear();
                TextLine.AddRange(File.ReadAllLines(TextFileName, System.Text.Encoding.GetEncoding("ks_c_5601-1987")));

                // Show article text to ListBox                
                ListArticle.Items.Clear();
                for (int i = 0; i < TextLine.Count; i++)
                {
                    ListArticle.Items.Add(TextLine[i]);
                }
            }
        }

        private void InsertArticle(int count)
        {
            if (count > TextLine.Count)
                return;

            TextLineCount++;

            // Set text space & subject & contents
            // Add Scroll Object which is space, subject title and contents
            // Article is organaized of space, subject title and contents
            if (TextLine[count] != "")  // Filter balnk string
            {
                if (TextLine[count].Contains("###"))
                {
                    string subject = TextLine[count].Replace("###", ""); // Remove "###"
                                        
                    TAP.SetText(PageName, "space1", "space");
                    TAP.SetText(PageName, "subject", subject);
                    TAP.SetText(PageName, "space2", "space");

                    TAP.AddScrollObject(PageName, "space1");
                    TAP.AddScrollObject(PageName, "subject");
                    TAP.AddScrollObject(PageName, "space2");
                }
                else
                {
                    TAP.SetText(PageName, "content", TextLine[count]);
                    TAP.AddScrollObject(PageName, "content");
                }
            }                            
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            // Query 'QueryAirScrollMargin' to TAP Server
            TAP.QueryAirScrollMargin(TAPI.eLayer.LAYER_SECTION_0);
        }

        // Message from TAP Server
        public void OnReceive(string text)
        {
            string Message = text + "\r\n";
            MessageView.AppendText(Message);

            // Stop timer as stop to query 'QueryAirScrollMargin' 
            // if it is generated message of 'FAILURE QUERY SCROLLMARGIN'
            if (text == "FAILURE QUERY SCROLLMARGIN ")
            {
                timer.Stop();
            }

            // Parser message
            if (Parser.Parse(text) == 0)
                return;
            
            TAPI.eTAPCommand command = Parser.GetCommand();
            switch (command)
            {
                case TAPI.eTAPCommand.TAP_COMMAND_Query:
                    {
                        TAPI.eTAPCommand command2 = Parser.GetNextCommand();
                        switch (command2)
                        {
                            case TAPI.eTAPCommand.TAP_COMMAND_Load:      // SUCCESS QUERY LOAD   : PageNames All
                                break;
                            case TAPI.eTAPCommand.TAP_COMMAND_ObjValue:  // SUCCESS QUERY OBJVALUE 
                                break;
                            case TAPI.eTAPCommand.TAP_COMMAND_ScrollMargin: // SUCCESS QUERY SCROLLMARGIN
                                {
                                    Parser.GetNextString();
                                    string strMargin = Parser.GetNextString();

                                    int ScrollMargin = Convert.ToInt32(strMargin);

                                    if (ScrollMargin < 300)
                                    {
                                        // Add a new Scroll object here
                                        InsertArticle(TextLineCount);
                                    }
                                }
                                break;
                        }
                    }
                    break;
            }
        }
    }

    /// <summary>
    /// Message Handler
    /// </summary>
    public class cMyHandler : TAPI.TAPEventHandler
    {
        protected TAPCrawl owner;
        public cMyHandler(TAPCrawl _owner)
        {
            owner = _owner;
        }
        public void Test()
        {
            System.Windows.Forms.MessageBox.Show("Hello");
        }
        public void OnConnect()
        {
            System.Windows.Forms.MessageBox.Show("Connected");
        }

        public void OnClose()
        {
        }

        public void OnReceive(string pData)
        {
            owner.OnReceive(pData);
        }
    }
}