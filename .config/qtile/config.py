# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen, Match
from libqtile.lazy import lazy

import iwlib

import os
import subprocess
import socket
import requests

MARGIN = 10
BORDER = 2
CORNER_RADIUS = 15
IS_LAPTOP = True

mod = "mod4"
terminal = "urxvt"
shell = "fish"

##### COLORS #####
colors = [["#2E3440", "#2E3440"], # panel background & inactive border
          ["#434758", "#434758"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#8FBCBB", "#8FBCBB"], # border line color for current tab
          ["#81A1C1", "#81A1C1"], # border line color for other tab and odd widgets
          ["#BF616A", "#BF616A"], # color for the even widgets
          ["#7a84a7", "#7a84a7"]] # window name

##### GROUP CLAMPING #####
def to_screen(screen):
    def f(qtile):
        qtile.cmd_to_screen(screen)

    return f

keys = [
    # Switch between windows in current stack pane
    Key([mod], "h", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "t", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    Key([mod, "shift", "control"], "z", lazy.screen.next_group()),
    Key([mod, "shift", "control"], "x", lazy.screen.prev_group()),
    # Launch programs
    Key([mod], "w", lazy.spawn("{} -e sh -c nmtui".format(terminal))),
    Key([mod], "v", lazy.spawn("emacsclient -nc")),
    Key([mod], "o", lazy.spawn("flameshot gui")),
    Key([mod], "s", lazy.spawn("write_stylus")),
    Key([mod], "b", lazy.spawn("brave")),

    # suspend system
    Key([mod, "shift"], "l", lazy.spawn("systemctl suspend")),

    # Move windows up or down in current stack
    Key([mod, "shift"], "h", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "shift"], "t", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Resize windows
    Key([mod], "Up", lazy.layout.grow()),
    Key([mod], "Down", lazy.layout.shrink()),
    Key([mod], "Left", lazy.layout.normalize()),
    Key([mod], "Right", lazy.layout.maximize()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn("{} -e {}".format(terminal, shell)), desc="Launch terminal"),

    # Run dmenu/dmenu scripts
    Key([mod], "e", lazy.spawn("rofi -show run"), desc="Run Rofi"),
    Key([mod], "f", lazy.spawn("rofi -show window"), desc="Window switcher"),
    Key([mod], "g", lazy.spawn("rofi -show filebrowser"), desc="Rofi Filebrowser"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "a", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "shift"], "p", lazy.restart(), desc="Restart qtile"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown qtile"),

    # general volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s 5%+")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 5%-")),
]

def get_brightness():
    return str(int((int(str(subprocess.Popen(["brightnessctl", "g"], stdout=subprocess.PIPE).communicate()[0])[2:-3]) / 255) * 100)) + "%"

def get_wifi():
    interface = iwlib.get_iwconfig('wlp2s0')
    quality = interface['stats']['quality']
    essid = bytes(interface['ESSID']).decode()
    return f"{essid} {int(quality/70*5)}"


##### GROUPS #####

@lazy.function
def to_group_and_follow(qtile, name):
    qtile.move_to_group(name)
    qtile.groups_map[name].cmd_toscreen()


group_names = [("1: Editor", {'layout': 'monadtall'}),
               ("2: Browser", {'layout': 'monadtall'}),
               ("3: Terminals", {'layout': 'monadtall'}),
               ("4: Discord", {'layout': 'monadtall'}),
               ("5: Write", {'layout': 'monadtall'}),
               ("6: Email", {'layout': 'monadtall'}),
               ("7: Notion", {'layout': 'monadtall'}),
               ("8", {'layout': 'monadtall'}),
               ("9", {'layout': 'floating'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group
    keys.append(Key([mod, "control"], str(i), to_group_and_follow(name))) # Send current window to another group and follow


# DEFAULT THEME SETTINGS FOR LAYOUTS #####
layout_theme = {"border_width": BORDER,
                "margin": MARGIN,
                "border_focus": colors[4][0],
                "border_normal": colors[0][0]
                }


layouts = [
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadTall(margin=MARGIN, border_width=BORDER, border_normal=colors[0][0], border_focus=colors[4][0], corner_radius=CORNER_RADIUS),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Floating(**layout_theme),
    # layout.RatioTile(),
    #layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# PROMPT #####
prompt = "[{} ]$".format(os.environ["USER"])

# DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="DejaVuSansMono Nerd Font",
    fontsize=12,
    padding=2,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()

# WIDGETS #####


def init_widgets_list():
    widgets_list = [
               widget.Sep(
                        linewidth = 0,
                        padding = 6,
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.Image(
                        background = colors[2],
                        filename = "/home/oscar/.config/qtile/icons/python.png",
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn("onboard")}
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 6,
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.GroupBox(font="Deja Vu Sans Mono",
                        fontsize = 11,
                        margin_y = 3,
                        margin_x = 0,
                        padding_y = 5,
                        padding_x = 5,
                        borderwidth = 3,
                        active = colors[2],
                        inactive = colors[2],
                        rounded = False,
                        highlight_color = colors[1],
                        highlight_method = "line",
                        this_current_screen_border = colors[3],
                        this_screen_border = colors [4],
                        other_current_screen_border = colors[0],
                        other_screen_border = colors[0],
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.Prompt(
                        prompt=prompt,
                        font="Deja Vu Sans Mono",
                        padding=10,
                        foreground = colors[3],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 40,
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.WindowName(
                        foreground = colors[6],
                        background = colors[0],
                        padding = 0
                        ),
               widget.TextBox(
                        text=" CPU:",
                        foreground=colors[2],
                        background=colors[0],
                        padding = 0,
                        fontsize=14
                        ),
               widget.CPU(
                        foreground = colors[2],
                        background = colors[0],
                        padding = 5,
                        format = "{load_percent}%"
                        ),
               widget.TextBox(
                        text='|',
                        background = colors[0],
                        foreground = colors[2],
                        padding=0,
                        fontsize=14
                        ),
               widget.TextBox(
                        text=" MEM:",
                        foreground=colors[2],
                        background=colors[0],
                        padding = 0,
                        fontsize=14
                        ),
               widget.Memory(
                        foreground = colors[2],
                        background = colors[0],
                        padding = 5,
                        measure_mem = 'G',
                        format = '{MemUsed: .1f}{mm}'
                        ),
               widget.TextBox(
                        text='|',
                        background = colors[0],
                        foreground = colors[2],
                        padding=0,
                        fontsize=14
                        ),
               widget.TextBox(
                       text=" WLAN:",
                        foreground=colors[2],
                        background=colors[0],
                        padding = 0
                        ),
               widget.GenPollText(
                        foreground=colors[2],
                        background=colors[0],
                        update_interval=1,
                        func=get_wifi
                       ),
               widget.TextBox(
                        text='|',
                        background = colors[0],
                        foreground = colors[2],
                        padding=0,
                        fontsize=14
                        ),
               widget.TextBox(
                       text=" BRT:",
                        foreground=colors[2],
                        background=colors[0],
                        padding = 0
                        ),
               widget.GenPollText(
                        foreground=colors[2],
                        background=colors[0],
                        update_interval=0.1,
                        func = get_brightness
                       ),
               widget.TextBox(
                        text='|',
                        background = colors[0],
                        foreground = colors[2],
                        padding=0,
                        fontsize=14
                        ),
               widget.TextBox(
                       text=" BATT:",
                        foreground=colors[2],
                        background=colors[0],
                        padding = 0
                        ),
               widget.Battery(
                        foreground=colors[2],
                        background=colors[0],
                        update_interval=1,
                        low_foreground="#FFFFFF",
                        format="{char} {percent:2.0%} {hour:d}:{min:02d}",
                       ),
               widget.TextBox(
                        text='|',
                        background = colors[0],
                        foreground = colors[2],
                        padding=0,
                        fontsize=14
                        ),
               widget.TextBox(
                        text=" VOL:",
                        foreground=colors[2],
                        background=colors[0],
                        padding = 0,
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn("pavucontrol")}
                        ),
               widget.Volume(
                         foreground = colors[2],
                         background = colors[0],
                         device = 'pulse'
               ),
               widget.TextBox(
                        text='|',
                        background = colors[0],
                        foreground = colors[2],
                        padding=0,
                        fontsize=14
                        ),
               widget.CurrentLayoutIcon(
                        custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                        foreground = colors[0],
                        background = colors[0],
                        padding = 0,
                        scale=0.7
                        ),
               widget.CurrentLayout(
                        foreground = colors[2],
                        background = colors[0],
                        padding = 5
                        ),
               widget.TextBox(
                        text='|',
                        background = colors[0],
                        foreground = colors[2],
                        padding=0,
                        fontsize=14
                        ),
               widget.Clock(
                        foreground = colors[2],
                        background = colors[0],
                        format="%A, %B %d %H:%M:%S "
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[0]
                        )
              ]
    return widgets_list

##### SCREENS ##### (TRIPLE MONITOR SETUP)

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2                       # Monitor 2 will display all widgets in widgets_list

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1, size=20))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod, "shift"], "Button1", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button3", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    Match(wm_class='confirm'),
    Match(wm_class='Onboard'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(wm_class='volume-osd.py')
], border_width=0)
auto_fullscreen = True
focus_on_window_activation = "focus"

@hook.subscribe.startup
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
