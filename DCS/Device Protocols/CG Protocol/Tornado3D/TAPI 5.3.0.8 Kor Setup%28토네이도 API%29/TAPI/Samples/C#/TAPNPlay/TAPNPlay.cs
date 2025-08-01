using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace TAPNPlay
{
    public partial class TAPNPlay : Form
    {
        protected TAPI.TAP TAP;
        protected TAPI.TAPParser Parser;
        protected cMyHandler MyHandler;
        protected string TcfFileName;

        public TAPNPlay()
        {
            InitializeComponent();

            TAP = new TAPI.TAP();
            Parser = new TAPI.TAPParser();

            try
            {
                //Engine.Open(TAPI.eVideoFormat.SD_486I, TAPI.eVideoBoard.VIDEO_VGA);
               // Engine.Open(TAPI.eVideoFormat.HD_1080I_29, TAPI.eVideoBoard.VIDEO_DSXMIO);
                MyHandler = new cMyHandler(this);

            }
            catch (Exception e)
            {
                System.Windows.Forms.MessageBox.Show(e.Message);
            }
        }

        public void Dispose()
        {
            TAP.Destroy();
        }

        private void Connect_Click(object sender, EventArgs e)
        {

            TAP.Connect(1, ServerIP.Text, Convert.ToInt32(ServerPort.Text), 1000, MyHandler);
        }

        private void Browse_Click(object sender, EventArgs e)
        {
            if (openTcfFileDialog.ShowDialog() == DialogResult.OK)
            {
                TcfFileName = openTcfFileDialog.FileName;
                TcfFileNameEdit.Text = TcfFileName;

                PageNameEdit.Text = openTcfFileDialog.FileName;// SafeFileName;
                string text = openTcfFileDialog.FileName;// FilSafeFileName;
                PageNameEdit.Text = text.Remove(text.Length - 4);
            }
        }

        private void Load_Click(object sender, EventArgs e)
        {
            TAP.LoadPage(TcfFileNameEdit.Text, PageNameEdit.Text);
        }

        private void Prepare_Click(object sender, EventArgs e)
        {

            TAP.PreparePage(PageNameEdit.Text, TAPI.eLayer.LAYER_SECTION_0, 1);
        }

        private void Play_Click(object sender, EventArgs e)
        {
            TAP.Play(TAPI.eLayer.LAYER_SECTION_0);
        }

        private void Clear_Click(object sender, EventArgs e)
        {
            //TAP.Stop();
            TAP.Out(TAPI.eLayer.LAYER_SECTION_0);
        }

        public void OnReceive(string text)
        {
            //textBox1.Text = text;

            string Message = text + "\r\n";
            MessageView.AppendText(Message);

            if(Parser.Parse(text) == 0)
                return;

            TAPI.eTAPCommand command = Parser.GetCommand();
            switch(command){
                case TAPI.eTAPCommand.TAP_COMMAND_Query:
                    {
                        TAPI.eTAPCommand command2 = Parser.GetNextCommand();
                        switch (command2){
                            case TAPI.eTAPCommand.TAP_COMMAND_Load:      // SUCCESS QUERY LOAD   : PageNames All
                                break;
                            case TAPI.eTAPCommand.TAP_COMMAND_ObjValue:  // SUCCESS QUERY OBJVALUE 
                                break;
                            case TAPI.eTAPCommand.TAP_COMMAND_ScrollMargin: // SUCCESS QUERY SCROLLMARGIN
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
        protected TAPNPlay owner;
        public cMyHandler(TAPNPlay _owner)
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
           // TAPNPlay theApp = (TAPNPlay)System.Windows.Forms.Form.ActiveForm;
        
            owner.OnReceive(pData);

        }
    }
}