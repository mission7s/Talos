namespace TAPNPlay
{
    partial class TAPNPlay
    {
        /// <summary>
        /// 필수 디자이너 변수입니다.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 사용 중인 모든 리소스를 정리합니다.
        /// </summary>
        /// <param name="disposing">관리되는 리소스를 삭제해야 하면 true이고, 그렇지 않으면 false입니다.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form 디자이너에서 생성한 코드

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.ServerPort = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.openTcfFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.Connect = new System.Windows.Forms.Button();
            this.Browse = new System.Windows.Forms.Button();
            this.TcfFileNameEdit = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.PageNameEdit = new System.Windows.Forms.TextBox();
            this.MessageView = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.Load = new System.Windows.Forms.Button();
            this.Prepare = new System.Windows.Forms.Button();
            this.Play = new System.Windows.Forms.Button();
            this.Clear = new System.Windows.Forms.Button();
            this.ServerIP = new System.Windows.Forms.TextBox();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(22, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(56, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "Server IP";
            // 
            // ServerPort
            // 
            this.ServerPort.Location = new System.Drawing.Point(276, 23);
            this.ServerPort.Name = "ServerPort";
            this.ServerPort.Size = new System.Drawing.Size(61, 21);
            this.ServerPort.TabIndex = 0;
            this.ServerPort.Text = "30002";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(203, 28);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(67, 12);
            this.label2.TabIndex = 1;
            this.label2.Text = "Server Port";
            // 
            // openTcfFileDialog
            // 
            this.openTcfFileDialog.FileName = "openTcfFileDialog";
            // 
            // Connect
            // 
            this.Connect.Location = new System.Drawing.Point(352, 18);
            this.Connect.Name = "Connect";
            this.Connect.Size = new System.Drawing.Size(101, 31);
            this.Connect.TabIndex = 22;
            this.Connect.Text = "Connect";
            this.Connect.UseVisualStyleBackColor = true;
            this.Connect.Click += new System.EventHandler(this.Connect_Click);
            // 
            // Browse
            // 
            this.Browse.Location = new System.Drawing.Point(352, 69);
            this.Browse.Name = "Browse";
            this.Browse.Size = new System.Drawing.Size(101, 23);
            this.Browse.TabIndex = 25;
            this.Browse.Text = "Browse...";
            this.Browse.UseVisualStyleBackColor = true;
            this.Browse.Click += new System.EventHandler(this.Browse_Click);
            // 
            // TcfFileNameEdit
            // 
            this.TcfFileNameEdit.Location = new System.Drawing.Point(84, 71);
            this.TcfFileNameEdit.Name = "TcfFileNameEdit";
            this.TcfFileNameEdit.Size = new System.Drawing.Size(253, 21);
            this.TcfFileNameEdit.TabIndex = 23;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(55, 74);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(23, 12);
            this.label3.TabIndex = 24;
            this.label3.Text = "Tcf";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(10, 101);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(68, 12);
            this.label4.TabIndex = 24;
            this.label4.Text = "PageName";
            // 
            // PageNameEdit
            // 
            this.PageNameEdit.Location = new System.Drawing.Point(84, 98);
            this.PageNameEdit.Name = "PageNameEdit";
            this.PageNameEdit.Size = new System.Drawing.Size(253, 21);
            this.PageNameEdit.TabIndex = 23;
            // 
            // MessageView
            // 
            this.MessageView.Location = new System.Drawing.Point(12, 151);
            this.MessageView.Multiline = true;
            this.MessageView.Name = "MessageView";
            this.MessageView.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.MessageView.Size = new System.Drawing.Size(325, 142);
            this.MessageView.TabIndex = 26;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(133, 136);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(102, 12);
            this.label5.TabIndex = 1;
            this.label5.Text = "[Message View]";
            // 
            // Load
            // 
            this.Load.Location = new System.Drawing.Point(352, 151);
            this.Load.Name = "Load";
            this.Load.Size = new System.Drawing.Size(101, 31);
            this.Load.TabIndex = 22;
            this.Load.Text = "Load";
            this.Load.UseVisualStyleBackColor = true;
            this.Load.Click += new System.EventHandler(this.Load_Click);
            // 
            // Prepare
            // 
            this.Prepare.Location = new System.Drawing.Point(352, 188);
            this.Prepare.Name = "Prepare";
            this.Prepare.Size = new System.Drawing.Size(101, 31);
            this.Prepare.TabIndex = 22;
            this.Prepare.Text = "Prepare";
            this.Prepare.UseVisualStyleBackColor = true;
            this.Prepare.Click += new System.EventHandler(this.Prepare_Click);
            // 
            // Play
            // 
            this.Play.Location = new System.Drawing.Point(352, 225);
            this.Play.Name = "Play";
            this.Play.Size = new System.Drawing.Size(101, 31);
            this.Play.TabIndex = 22;
            this.Play.Text = "Play";
            this.Play.UseVisualStyleBackColor = true;
            this.Play.Click += new System.EventHandler(this.Play_Click);
            // 
            // Clear
            // 
            this.Clear.Location = new System.Drawing.Point(352, 262);
            this.Clear.Name = "Clear";
            this.Clear.Size = new System.Drawing.Size(101, 31);
            this.Clear.TabIndex = 22;
            this.Clear.Text = "Clear";
            this.Clear.UseVisualStyleBackColor = true;
            this.Clear.Click += new System.EventHandler(this.Clear_Click);
            // 
            // ServerIP
            // 
            this.ServerIP.Location = new System.Drawing.Point(84, 23);
            this.ServerIP.Name = "ServerIP";
            this.ServerIP.Size = new System.Drawing.Size(106, 21);
            this.ServerIP.TabIndex = 27;
            this.ServerIP.Text = "127.0.0.1";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(84, 308);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(253, 21);
            this.textBox1.TabIndex = 23;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(9, 312);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(66, 12);
            this.label6.TabIndex = 24;
            this.label6.Text = "OnReceive";
            // 
            // TAPNPlay
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(472, 341);
            this.Controls.Add(this.ServerIP);
            this.Controls.Add(this.MessageView);
            this.Controls.Add(this.Browse);
            this.Controls.Add(this.PageNameEdit);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.TcfFileNameEdit);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.Clear);
            this.Controls.Add(this.Play);
            this.Controls.Add(this.Prepare);
            this.Controls.Add(this.Load);
            this.Controls.Add(this.Connect);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.ServerPort);
            this.Name = "TAPNPlay";
            this.Text = "TAPNPlay";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox ServerPort;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.OpenFileDialog openTcfFileDialog;
        private System.Windows.Forms.Button Connect;
        private System.Windows.Forms.Button Browse;
        private System.Windows.Forms.TextBox TcfFileNameEdit;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox PageNameEdit;
        private System.Windows.Forms.TextBox MessageView;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Button Load;
        private System.Windows.Forms.Button Prepare;
        private System.Windows.Forms.Button Play;
        private System.Windows.Forms.Button Clear;
        private System.Windows.Forms.TextBox ServerIP;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label label6;
    }
}

