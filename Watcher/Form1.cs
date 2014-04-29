using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Watcher
{
    public partial class Form1 : Form
    {
        private List<WatchLine> watchLines;

        public Form1()
        {
            InitializeComponent();
            watchLines = new List<Watcher.WatchLine>();
            addWatcherLine(checkBox1, comboBox1, textBox1, button1, "coffee", "js\\");
            addWatcherLine(checkBox2, comboBox2, textBox2, button2, "less", "css\\");
            checkBox1.CheckedChanged += checkBox1_CheckedChanged;
            checkBox2.CheckedChanged += checkBox2_CheckedChanged;
        }

        private void addWatcherLine(CheckBox chb, ComboBox cb, TextBox tb, Button b, string what, string where)
        {
            watchLines.Add(new Watcher.WatchLine(chb, cb, tb, b, what, where));
        }
               
        private void button1_Click(object sender, EventArgs e)
        {
            watchLines[0].onSettingsChanged();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            watchLines[1].onSettingsChanged();
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            watchLines[0].onSettingsChanged();
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            watchLines[1].onSettingsChanged();
        }
    }
}
