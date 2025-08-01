namespace TAPCrawl
{
    partial class TAPCrawl
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.ServerIP = new System.Windows.Forms.TextBox();
            this.Browse = new System.Windows.Forms.Button();
            this.TcfFileNameEdit = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.Clear = new System.Windows.Forms.Button();
            this.Play = new System.Windows.Forms.Button();
            this.Prepare = new System.Windows.Forms.Button();
            this.Load = new System.Windows.Forms.Button();
            this.Connect = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.ServerPort = new System.Windows.Forms.TextBox();
            this.openTcfFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.TextBrowse = new System.Windows.Forms.Button();
            this.TextFileNameEdit = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.timer = new System.Windows.Forms.Timer(this.components);
            this.MessageView = new System.Windows.Forms.TextBox();
            this.ListArticle = new System.Windows.Forms.ListBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label4 = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // ServerIP
            // 
            this.ServerIP.Location = new System.Drawing.Point(85, 24);
            this.ServerIP.Name = "ServerIP";
            this.ServerIP.Size = new System.Drawing.Size(106, 21);
            this.ServerIP.TabIndex = 45;
            this.ServerIP.Text = "127.0.0.1";
            // 
            // Browse
            // 
            this.Browse.Location = new System.Drawing.Point(496, 82);
            this.Browse.Name = "Browse";
            this.Browse.Size = new System.Drawing.Size(101, 23);
            this.Browse.TabIndex = 43;
            this.Browse.Text = "Browse...";
            this.Browse.UseVisualStyleBackColor = true;
            this.Browse.Click += new System.EventHandler(this.Browse_Click);
            // 
            // TcfFileNameEdit
            // 
            this.TcfFileNameEdit.Location = new System.Drawing.Point(97, 84);
            this.TcfFileNameEdit.Name = "TcfFileNameEdit";
            this.TcfFileNameEdit.Size = new System.Drawing.Size(386, 21);
            this.TcfFileNameEdit.TabIndex = 38;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(11, 87);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(53, 12);
            this.label3.TabIndex = 42;
            this.label3.Text = "TCFFile:";
            // 
            // Clear
            // 
            this.Clear.Location = new System.Drawing.Point(384, 457);
            this.Clear.Name = "Clear";
            this.Clear.Size = new System.Drawing.Size(101, 31);
            this.Clear.TabIndex = 32;
            this.Clear.Text = "Clear";
            this.Clear.UseVisualStyleBackColor = true;
            this.Clear.Click += new System.EventHandler(this.Clear_Click);
            // 
            // Play
            // 
            this.Play.Location = new System.Drawing.Point(262, 457);
            this.Play.Name = "Play";
            this.Play.Size = new System.Drawing.Size(101, 31);
            this.Play.TabIndex = 35;
            this.Play.Text = "Play";
            this.Play.UseVisualStyleBackColor = true;
            this.Play.Click += new System.EventHandler(this.Play_Click);
            // 
            // Prepare
            // 
            this.Prepare.Location = new System.Drawing.Point(142, 457);
            this.Prepare.Name = "Prepare";
            this.Prepare.Size = new System.Drawing.Size(101, 31);
            this.Prepare.TabIndex = 34;
            this.Prepare.Text = "Prepare";
            this.Prepare.UseVisualStyleBackColor = true;
            this.Prepare.Click += new System.EventHandler(this.Prepare_Click);
            // 
            // Load
            // 
            this.Load.Location = new System.Drawing.Point(22, 457);
            this.Load.Name = "Load";
            this.Load.Size = new System.Drawing.Size(101, 31);
            this.Load.TabIndex = 33;
            this.Load.Text = "Load";
            this.Load.UseVisualStyleBackColor = true;
            this.Load.Click += new System.EventHandler(this.Load_Click);
            // 
            // Connect
            // 
            this.Connect.Location = new System.Drawing.Point(484, 17);
            this.Connect.Name = "Connect";
            this.Connect.Size = new System.Drawing.Size(101, 32);
            this.Connect.TabIndex = 36;
            this.Connect.Text = "Connect";
            this.Connect.UseVisualStyleBackColor = true;
            this.Connect.Click += new System.EventHandler(this.Connect_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(24, 286);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(102, 12);
            this.label5.TabIndex = 29;
            this.label5.Text = "[Message View]";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(228, 29);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(71, 12);
            this.label2.TabIndex = 30;
            this.label2.Text = "Server Port:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(18, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(60, 12);
            this.label1.TabIndex = 31;
            this.label1.Text = "Server IP:";
            // 
            // ServerPort
            // 
            this.ServerPort.Location = new System.Drawing.Point(309, 24);
            this.ServerPort.Name = "ServerPort";
            this.ServerPort.Size = new System.Drawing.Size(61, 21);
            this.ServerPort.TabIndex = 28;
            this.ServerPort.Text = "30002";
            // 
            // openTcfFileDialog
            // 
            this.openTcfFileDialog.FileName = "openTcfFileDialog";
            // 
            // TextBrowse
            // 
            this.TextBrowse.Location = new System.Drawing.Point(496, 111);
            this.TextBrowse.Name = "TextBrowse";
            this.TextBrowse.Size = new System.Drawing.Size(101, 23);
            this.TextBrowse.TabIndex = 48;
            this.TextBrowse.Text = "Browse...";
            this.TextBrowse.UseVisualStyleBackColor = true;
            this.TextBrowse.Click += new System.EventHandler(this.TextBrowse_Click);
            // 
            // TextFileNameEdit
            // 
            this.TextFileNameEdit.Location = new System.Drawing.Point(97, 111);
            this.TextFileNameEdit.Name = "TextFileNameEdit";
            this.TextFileNameEdit.Size = new System.Drawing.Size(386, 21);
            this.TextFileNameEdit.TabIndex = 46;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(11, 114);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(58, 12);
            this.label7.TabIndex = 47;
            this.label7.Text = "Text File:";
            // 
            // timer
            // 
            this.timer.Tick += new System.EventHandler(this.timer_Tick);
            // 
            // MessageView
            // 
            this.MessageView.Location = new System.Drawing.Point(12, 301);
            this.MessageView.Multiline = true;
            this.MessageView.Name = "MessageView";
            this.MessageView.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.MessageView.Size = new System.Drawing.Size(595, 142);
            this.MessageView.TabIndex = 49;
            // 
            // ListArticle
            // 
            this.ListArticle.FormattingEnabled = true;
            this.ListArticle.ItemHeight = 12;
            this.ListArticle.Location = new System.Drawing.Point(12, 162);
            this.ListArticle.Name = "ListArticle";
            this.ListArticle.Size = new System.Drawing.Size(595, 112);
            this.ListArticle.TabIndex = 50;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.ServerPort);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.Connect);
            this.groupBox1.Controls.Add(this.ServerIP);
            this.groupBox1.Location = new System.Drawing.Point(12, 10);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(595, 58);
            this.groupBox1.TabIndex = 51;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "groupBox1";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(24, 147);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(84, 12);
            this.label4.TabIndex = 52;
            this.label4.Text = "[Article View]";
            // 
            // TAPCrawl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(619, 508);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.ListArticle);
            this.Controls.Add(this.MessageView);
            this.Controls.Add(this.TextBrowse);
            this.Controls.Add(this.TextFileNameEdit);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.Browse);
            this.Controls.Add(this.TcfFileNameEdit);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.Clear);
            this.Controls.Add(this.Play);
            this.Controls.Add(this.Prepare);
            this.Controls.Add(this.Load);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.groupBox1);
            this.Name = "TAPCrawl";
            this.Text = "TAPCrawl";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.OpenFileDialog openTcfFileDialog;
        private System.Windows.Forms.TextBox ServerIP;
        private System.Windows.Forms.Button Browse;
        private System.Windows.Forms.TextBox TcfFileNameEdit;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button Clear;
        private System.Windows.Forms.Button Play;
        private System.Windows.Forms.Button Prepare;
        private System.Windows.Forms.Button Load;
        private System.Windows.Forms.Button Connect;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox ServerPort;
        private System.Windows.Forms.Button TextBrowse;
        private System.Windows.Forms.TextBox TextFileNameEdit;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Timer timer;
        private System.Windows.Forms.TextBox MessageView;
        private System.Windows.Forms.ListBox ListArticle;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label4;        
    }
}

