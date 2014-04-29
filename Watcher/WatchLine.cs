using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Collections;

namespace Watcher
{
    class WatchLine
    {
        //variables
        private CheckBox chb;
        private ComboBox cb;
        private TextBox tb;
        private Button b;
        private string what, where;
        private WatcherClass watcher;
        private bool working;

        //constructor
        public WatchLine(CheckBox chb, ComboBox cb, TextBox tb, Button b, string what, string where)
        {
            this.chb = chb;
            this.cb = cb;
            this.tb = tb;
            this.b = b;
            this.what = what;
            this.where = where;
            working = true;
            setWatcher();
            initControls();
        }

        //methods
        private void initControls()
        {
            //init checkbox
            chb.Checked = working;
            //init combobox
            cb.Items.AddRange((new ArrayList() { "coffee", "less" }).ToArray());
            cb.SelectedItem = what;
            //init textbox
            tb.Text = where;
        }

        private void setWatcher()        
        {
            if (watcher != null) watcher.deactivate();
            switch (what)
            {
                case "coffee":
                    watcher = new WatcherCoffee(what, where);
                    break;
                case "less":
                    watcher = new WatcherLess(what, where);
                    break;
            }
        }

        private void removeWatcher()
        {
            watcher.deactivate();
        }

        private void getWorking()
        {
            working = chb.Checked;
        }

        private void getWhat()
        {
            what = cb.SelectedItem.ToString();
        }

        private void getWhere()
        {
            where = tb.Text;
        }

        public void onSettingsChanged()
        {
            getWorking();
            getWhat();
            getWhere();
            if (working)
            {
                setWatcher();
            }
            else
            {
                removeWatcher();
            }
        }
    }
}
