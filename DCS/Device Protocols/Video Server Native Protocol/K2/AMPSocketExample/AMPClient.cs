using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Net;

namespace AMPSocketExample
{
    class AMPClient
    {
        private Socket _socket;

        /// <summary>
        /// Creates an AMP connection to the hostname and channel specified.
        /// </summary>
        public AMPClient(string hostName, string channelName)
        {
            if (hostName == null || hostName=="") throw new Exception("Hostname cannot be blank.");

            // Resolve the hostname using DNS
            IPHostEntry hostEntry = Dns.GetHostEntry(hostName);
            if (hostEntry.AddressList.Length == 0) throw new Exception("Could not resolve hostname.");
            IPAddress address = hostEntry.AddressList[0];

            // Create an endpoint to the IP address that was resolved, using AMP port # 3811.
            IPEndPoint endPoint = new IPEndPoint(address, 3811);

            // Create and connect a TCP socket
            Console.WriteLine("Connecting to host {0}...", hostName);
            _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            _socket.Connect(endPoint);

            // Set the send and receive timeouts.
            _socket.ReceiveTimeout = 5000;
            _socket.SendTimeout = 5000;

            // Create the AMP connection.  Refer to the document "K2 Protocol Developer's Guide" for details.
            string strCommand;
            if (channelName == null || channelName == "")
            {
                // AMP channel-less connection
                Console.WriteLine("Creating AMP channel-less connection...");
                strCommand = ("CRAT00014\n");
            }
            else
            {
                // AMP channel connection 
                Console.WriteLine("Creating AMP connection to channel {0}...", channelName);
                strCommand = String.Format("CRAT{0:0000}{1}{2:00}{3}\n", channelName.Length + 3, 2, channelName.Length, channelName);
            }

            // Convert the command string to a byte array, and send the data to the socket.
            byte[] byteData = System.Text.Encoding.ASCII.GetBytes(strCommand);
            if (_socket.Send(byteData) != byteData.Length) throw new Exception("Error sending socket data.");

            // Receive the response to the connection request.  The reply will either be "1001" (ACK) or "1111" (NAK).
            const int replySize = 4;
            byte[] receiveBuffer = new byte[replySize];
            if (_socket.Receive(receiveBuffer) != replySize)
            {
                throw new Exception("Response to connection request did not return the expected number of bytes.");
            }

            // Make sure the connection was successful.
            string strReply = System.Text.Encoding.ASCII.GetString(receiveBuffer, 0, replySize);
            if (strReply == "1111")
            {
                throw new Exception("CRAT command failed -- system returned NAK reply. Verify that the channel is configured for AMP control.");
            }
            else if (strReply != "1001")
            {
                throw new Exception(string.Format("CRAT command failed. System returned unknown reply {0}", strReply));
            }
        }

        /// <summary>
        /// Sends the "STOP" command to close the AMP connection, and then closes the socket connection.
        /// </summary>
        public void Disconnect()
        {
            if (_socket == null || !_socket.Connected) throw new Exception("Socket is not yet connected.");

            string strCommand = "STOP0000\n";
            byte[] byteData = System.Text.Encoding.ASCII.GetBytes(strCommand);
            if (_socket.Send(byteData) != byteData.Length) throw new Exception("Error sending socket data.");

            // Receive the response.  The reply will either be "1001" (ACK) or "1111" (NAK).
            byte[] receiveBuffer = new byte[4];
            int replyLen = _socket.Receive(receiveBuffer);
            string strReply = System.Text.Encoding.ASCII.GetString(receiveBuffer, 0, replyLen);
            if (strReply != "1001") Console.WriteLine("Warning, STOP command did not return ACK reply.");

            // Close the socket
            _socket.Close();
            _socket = null;
        }

        /// <summary>
        /// Sends the specified AMP command, and reads the response.  The command is specified as a string of hexadecimal bytes,
        /// and the reply is returned as an array of byte values.  If the isExtendedReply argument is set to true,
        /// when reading the reply data we will use the number of bytes specified by the "actual byte count" value.
        /// </summary>
        public byte[] SendCommand(string command, bool isExtendedReply)
        {
            byte[] sendBytes;
            byte[] replyBytes;

            if (_socket == null || !_socket.Connected) throw new Exception("Socket is not yet connected.");

            // AMP protocol only allows the complete command to take up to a maximum of 9999 bytes
            // due to the format of the length (4 decimal characters) after the CMDS string.
            if (command.Length > 9999)
            {
                throw new Exception(string.Format("Error sending AMP command. Data size ({0} bytes) exceeds maximum allowed of 9999 bytes.", command.Length));
            }

            // Format the socket command by adding the CMDSxxxx header.
            string sendString = string.Format("CMDS{0:0000}{1}\n", command.Length, command);
            sendBytes = System.Text.Encoding.ASCII.GetBytes(sendString);

            // Send the command to the server.
            _socket.Send(sendBytes);

            // Read the first byte of the response (CMD1)
            byte cmd1 = ReadByte();

            // If we are expecting a response in the extended format, use the "actual byte count" value
            // to determine how much reply data is to be expected.  Otherwise, read the amount of data 
            // based on the data length specified in the lower nibble of the CMD1 byte.
            if (isExtendedReply)
            {
                // Read the second byte of the response (CMD2)
                byte cmd2 = ReadByte();
                // Read the extended byte count.
                byte[] extBc = new byte[2];
                extBc[0] = ReadByte();
                extBc[1] = ReadByte();
                byte[] tempExtBc = new byte[] { extBc[1], extBc[0] };
                UInt16 dataLen = BitConverter.ToUInt16(tempExtBc, 0);
                // Read the expected amount of data.  Socket commands do not include an extra checksum byte as RS422 does.
                byte[] data = ReadBytes(dataLen);
                // Total length of data for a socket reply in extended format: CMD1 + CMD2 + BC1 + BC2 + DATALEN
                int totalLen = dataLen + 4;
                // Assemble the complete reply into the 'replyBytes' array.
                replyBytes = new byte[totalLen];
                replyBytes[0] = cmd1;
                replyBytes[1] = cmd2;
                replyBytes[2] = extBc[0];
                replyBytes[3] = extBc[1];
                Array.Copy(data, 0, replyBytes, 4, data.Length);
            }
            else
            {
                // Extract the response data length from the lower nibble of the CMD1 byte.
                int dataLen = (cmd1 & 0x0F);
                // Bytes remaining to read: the CMD2 byte, plus the length of data expected.
                // For socket connections, there is no checksum byte added like there is for RS422.
                int bytesToRead = dataLen + 1;
                // Read the remaining bytes of the response.
                byte[] data = ReadBytes(bytesToRead);
                // Total length also includes the cmd1 byte that was read previously.
                int totalLen = bytesToRead + 1;
                // Assemble the complete reply into the 'replyBytes' array.
                replyBytes = new byte[totalLen];
                replyBytes[0] = cmd1;
                Array.Copy(data, 0, replyBytes, 1, data.Length);
            }

            return replyBytes;
        }

        /// <summary>
        /// Reads and returns one byte of data from an AMP command reply.
        /// This actually involves reading two bytes of data from the network, since data is returned as a hexadecimal string.
        /// </summary>
        private byte ReadByte()
        {
            byte[] b = new byte[2];
            if (_socket.Receive(b) != 2) throw new Exception("Failed to read data from socket");
            string str = ASCIIEncoding.ASCII.GetString(b);
            return Convert.ToByte(str, 16);
        }

        /// <summary>
        /// Reads and returns the specified number of bytes of data from an AMP command reply.
        /// This actually involves reading two bytes of data from the network for each byte, since data is returned as a hexadecimal string.
        /// </summary>
        private byte[] ReadBytes(int count)
        {
            int totalToRead = count * 2;
            byte[] b = new byte[totalToRead];
            int totalRead = 0;
            while (totalRead < totalToRead)
            {
                int numRead = _socket.Receive(b, totalRead, (totalToRead - totalRead), SocketFlags.None);
                totalRead += numRead;
            }
            string str = ASCIIEncoding.ASCII.GetString(b);
            return HexStringToByteArray(str);
        }

        /// <summary>
        /// Converts a string representing hex numbers into their equivalent byte values (2 characters per byte).
        /// Example: "A005" --> { 0xA0, 0x05 }
        /// </summary>
        public byte[] HexStringToByteArray(string hexString)
        {
            if (hexString == null) return new byte[] { };
            if (hexString.Length % 2 != 0) throw new Exception("HexStringToByteArray: Input string must be an even number of characters.");

            byte[] byteArray = new byte[hexString.Length / 2];
            for (int i = 0; i < (hexString.Length / 2); i++)
            {
                byteArray[i] = Convert.ToByte(hexString.Substring(i * 2, 2), 16);
            }
            return byteArray;
        }

        /// <summary>
        /// Sends the A0.0F "Get Working Folder Request" command and returns the response.
        /// </summary>
        public string GetWorkingFolderRequest()
        {
            // Send the command and receive the response.
            byte[] reply = SendCommand("A00F", true);

            // Format of the expected reply data: [0x82] [0x0F] [ExtBC1] [ExtBC2] [Len1] [Len2] [FolderName]
            // Verify that the expected response was received, and extract the folder name string from the reply data.
            if (reply[0] == 0x82 && reply[1] == 0x0F)
            {
                // Extract the folder name length
                byte[] lengthBytes = new byte[] { reply[5], reply[4] };
                Int16 folderNameLen = BitConverter.ToInt16(lengthBytes, 0);
                // Extract and return the folder name string.
                return Encoding.UTF8.GetString(reply, 6, folderNameLen);
            }
            else
            {
                throw new Exception("GetWorkingFolderRequest returned an invalid reply.");
            }
        }

        /// <summary>
        /// Sends the 20.61 "EE On" command (enables E-to-E mode on the channel).
        /// </summary>
        public void EEOn()
        {
            // Send the command and receive the response.
            byte[] reply = SendCommand("2061", false);

            // Verify that the expected ACK reply was received.
            if (! (reply[0] == 0x10 && reply[1] == 0x01))
            {
                throw new Exception("EEOn command did not return ACK reply.");
            }

        }

    }
}
