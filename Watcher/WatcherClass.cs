using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace Watcher
{
    abstract class WatcherClass
    {
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hwnd, int cmd);

        //variables
        protected string path, what, where;
        protected string[] files;
        protected Process process;
        protected string batchFileName;
        protected bool activated;
        protected System.Timers.Timer timer;
        protected string[] prevFiles;

        //abstract methods
        abstract protected void makeBatchFile();

        //constructor
        public WatcherClass(string what, string where)
        {
            this.what = what;
            this.where = where;
            path = AppDomain.CurrentDomain.BaseDirectory;

            prevFiles = new string[] { };
            activated = false;
            timer = new System.Timers.Timer(500);
            timer.Elapsed += scanFolder;
            timer.Start();
        }

        //methods
        public void activate()
        {
            process = new System.Diagnostics.Process();
            process.StartInfo.FileName = path + batchFileName;
            process.Start();

            /////////////////////////////
            //minimizing 
            System.Timers.Timer t = new System.Timers.Timer(100);
            t.AutoReset = false;
            t.Elapsed += (object source, System.Timers.ElapsedEventArgs eea) =>
            {
                ShowWindow(process.MainWindowHandle, 6);
            };
            t.Start();
            /////////////////////////////

            activated = true;
        }

        public void deactivate()
        {
            try
            {
                process.CloseMainWindow();
                process.Kill();
            }
            catch (Exception e)
            {
            }
            activated = false;
        }

        private void scanFolder(object source, System.Timers.ElapsedEventArgs eea)
        {
            try
            {
                files = Directory.GetFiles(path + where, "*." + what);
                if (!Enumerable.SequenceEqual(files, prevFiles))
                {
                    makeBatchFile();
                    if (activated) deactivate();
                    activate();
                }
                prevFiles = files;
            }
            catch (Exception e)
            {
            }
        }

        //destructor
        ~WatcherClass()
        {
            timer.Stop();
            deactivate();
        }
    }
}
