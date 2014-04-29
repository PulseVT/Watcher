using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Watcher
{
    class WatcherLess : WatcherClass
    {
        //constructor
        public WatcherLess(string what, string where)
            : base(what, where)
        {
            batchFileName = "_watch__less.bat";
        }

        //methods
        protected override void makeBatchFile()
        {
            File.WriteAllLines(path + batchFileName, new List<string>() { "", "cd ./css", "watch-less" }, Encoding.UTF8); 
        }
    }
}
