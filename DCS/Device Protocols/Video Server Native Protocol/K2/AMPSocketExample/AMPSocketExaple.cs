// This is a small example program to demonstrate the minimum steps involved
// to create an AMP socket connection, send a command and receive the response,
// and disconnect.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace AMPSocketExample
{
    class AMPSocketExaple
    {
        static void Main(string[] args)
        {
            if (args.Length < 2)
            {
                Console.WriteLine("Usage: {0} <hostname> <channel>", Process.GetCurrentProcess().ProcessName);
                Console.WriteLine("Example: {0} k2-client1 vtr1", Process.GetCurrentProcess().ProcessName);
                return;
            }
            
            string hostName = args[0];
            string channel = args[1];

            AMPClient client = new AMPClient(hostName, channel);

            Console.WriteLine("Requesting working folder...");
            string workingFolder = client.GetWorkingFolderRequest();
            Console.WriteLine("Current working folder: {0}", workingFolder);

            Console.WriteLine("Enabling E-to-E mode...");
            client.EEOn();

            Console.WriteLine("Disconnecting...");
            client.Disconnect();
        }
    }
}
