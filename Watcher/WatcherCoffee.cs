using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Watcher
{
    class WatcherCoffee : WatcherClass
    {
        //constructor
        public WatcherCoffee(string what, string where)
            : base(what, where)
        {
            batchFileName = "_watch__coffee.bat";
        }

        //methods
        override protected void makeBatchFile()
        {
            List<string> lines = new List<string>() { "", "cd js", "coffee -o . -j app.js -c -w ^" };
            for (int i = 0; i < files.Length; i++)
            {
                string file = files[i];
                string[] tokens = file.Split(new string[] { "\\" }, StringSplitOptions.RemoveEmptyEntries);
                file = tokens.Last();
                lines.Add(file + " ^");
            }
            File.WriteAllLines(path + batchFileName, lines, Encoding.UTF8);
        }
    }
}
