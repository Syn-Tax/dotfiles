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
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

import os
import subprocess
import socket
import requests

MARGIN = 10
BORDER = 1

mod = "mod4"
terminal = "urxvt"

##### COLORS #####
colors = [["#282a36", "#282a36"], # panel background & inactive border
          ["#434758", "#434758"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#ff5555", "#ff5555"], # border line color for current tab
          ["#bf5363", "#bf5363"], # border line color for other tab and odd widgets
          ["#7a84a7", "#7a84a7"], # color for the even widgets
          ["#7a84a7", "#7a84a7"]] # window name

##### GROUP CLAMPING #####
def to_screen(screen):
    def f(qtile):
        qtile.cmd_to_screen(screen)

    return f

keys = [
    # Switch between windows in current stack pane
    Key([mod], "t", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "h", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    # Launch programs
    Key([mod], "f", lazy.spawn("urxvt -e sh -c ranger")),
    Key([mod], "v", lazy.spawn("emacs")),
    Key([mod], "p", lazy.spawn("flameshot gui -p /home/oscar/screenshots/")),

    # suspend system
    Key([mod, "shift"], "l", lazy.spawn("systemctl suspend")),

    # Move windows up or down in current stack
    Key([mod, "control"], "t", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "control"], "h", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Resize windows
    Key([mod, "control"], "Up", lazy.layout.grow()),
    Key([mod, "control"], "Down", lazy.layout.shrink()),
    Key([mod, "control"], "Left", lazy.layout.normalise()),
    Key([mod, "control"], "Right", lazy.layout.maximise()),

    # moving screens
    Key([mod, "shift"], "h", lazy.function(to_screen(2))),
    Key([mod, "shift"], "n", lazy.function(to_screen(1))),
    Key([mod, "shift"], "t", lazy.function(to_screen(0))),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Run dmenu/dmenu scripts
    Key([mod], "e", lazy.spawn("dmenu_run -m 0"), desc="Run Dmenu"),
    Key([mod], "g", lazy.spawn("/home/oscar/scripts/bookmenu")),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "a", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "shift"], "p", lazy.restart(), desc="Restart qtile"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown qtile"),

    # general volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 2%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 2%-")),
]

def weather():
    url = "https://api.climacell.co/v3/weather/realtime"

    querystring = {"lat":"56.434","lon":"-2.943","unit_system":"si","fields":"wind_speed:knots,wind_gust:knots,wind_direction","apikey":"SK6KWrtF7LufrgajNY4AN2mjs4xUkotF"}

    response = requests.request("GET", url, params=querystring)
      
    if response.status_code == requests.codes.ok:
        data = response.json()
        wind_direction = data["wind_direction"]["value"]
        wind_speed_kts = data["wind_speed"]["value"]
        wind_gust = data["wind_gust"]["value"]
            
        bff = 0

        if wind_speed_kts > 1:
            bff = 1
        if wind_speed_kts > 4:
            bff = 2
        if wind_speed_kts > 7:
            bff = 3
        if wind_speed_kts > 11:
            bff = 4
        if wind_speed_kts > 17:
            bff = 5
        if wind_speed_kts > 22:
            bff = 6
        if wind_speed_kts > 28:
            bff = 7
        if wind_speed_kts > 34:
            bff = 8
        if wind_speed_kts > 41:
            bff = 9
        if wind_speed_kts > 48:
            bff = 10
        if wind_speed_kts > 56:
            bff = 11
        if wind_speed_kts > 64:
            bff = 12

        
    wind_speed_kts = int(float(wind_speed_kts))
    wind_gust = int(float(wind_gust))
    if wind_speed_kts < 10:
        wind_speed_kts = "0{}".format(wind_speed_kts)
    if wind_gust < 10:
        wind_gust = "0{}".format(wind_gust)

    if wind_direction < 10:
        wind_direction = "00{}".format(int(float(wind_direction)))
    elif wind_direction < 100:
        wind_direction = "0{}".format(int(float(wind_direction)))

    text = "{0}@{1} G{2} [{3}]".format(wind_direction, wind_speed_kts, wind_gust, bff)
    return text

##### GROUPS #####
group_names = [("1: Editor", {'layout': 'monadtall'}),
               ("2: Chrome", {'layout': 'monadtall'}),
               ("3: Terminals", {'layout': 'monadwide'}),
               ("4: Discord", {'layout': 'monadwide'}),
               ("5: Spotify", {'layout': 'monadtall'}),
               ("6: Email", {'layout': 'monadtall'}),
               ("7", {'layout': 'monadtall'}),
               ("8", {'layout': 'monadtall'}),
               ("9", {'layout': 'monadtall'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    if name in ["1: Editor", "2: Chrome", "5: Spotify", "8"]:
        keys.append(Key([mod], str(i), lazy.function(to_screen(0)), lazy.group[name].toscreen()))        # Switch to another group
        keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group
    elif name in ["4: Discord", "7"]:
        keys.append(Key([mod], str(i), lazy.function(to_screen(1)), lazy.group[name].toscreen()))        # Switch to another group
        keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group
    else:
        keys.append(Key([mod], str(i), lazy.function(to_screen(2)), lazy.group[name].toscreen()))        # Switch to another group
        keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group



##### DEFAULT THEME SETTINGS FOR LAYOUTS #####
layout_theme = {"border_width": 0,
                "margin": 6,
                "border_focus": "e1acff",
                "border_normal": "1D2330"
                }


layouts = [
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    layout.MonadTall(margin=MARGIN, border_width=BORDER, border_normal=colors[0][0], border_focus=colors[4][0]),
    layout.MonadWide(margin=MARGIN, border_width=BORDER, border_normal=colors[0][0], border_focus=colors[4][0]),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]



##### PROMPT #####
prompt = "[{} ]$".format(os.environ["USER"])

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="Deja Vu Sans Mono for Powerline",
    fontsize = 12,
    padding = 2,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()

##### WIDGETS #####

def init_widgets_list(visible_groups, type_screen):
    if type_screen == 0:
        widgets_list = [
               widget.Sep(
                        linewidth = 0,
                        padding = 6,
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.GroupBox(font="Deja Vu Sans Mono",
                        fontsize = 9,
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
                        background = colors[0],
                        visible_groups=visible_groups
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
                        text=u'\uE0B2',
                        background = colors[0],
                        foreground = colors[4],
                        padding=0,
                        fontsize=20
                        
                        ),
               widget.TextBox(
                        text=" CPU:",
                        foreground=colors[2],
                        background=colors[4],
                        padding = 0,
                        fontsize=14
                        ),
               widget.CPU(
                        foreground = colors[2],
                        background = colors[4],
                        padding = 5,
                        format = "{load_percent}%"
                        ),
               widget.TextBox(
                        text=u'\uE0B2',
                        background = colors[4],
                        foreground = colors[5],
                        padding=0,
                        fontsize=20
                        ),
               widget.TextBox(
                        text=" MEM:",
                        foreground=colors[2],
                        background=colors[5],
                        padding = 0,
                        fontsize=14
                        ),
               widget.Memory(
                        foreground = colors[2],
                        background = colors[5],
                        padding = 5
                        ),
               widget.TextBox(
                       text=u'\uE0B2',
                       background = colors[5],
                       foreground = colors[4],
                       padding=0,
                       fontsize=20
                       ),
               widget.GenPollText(
                       background = colors[4],
                       foreground = colors[2],
                       padding = 5,
                       fontsize = 14,
                       func = weather,
                       update_interval = 300,
                       ),
               widget.TextBox(
                        text=u'\uE0B2',
                        background = colors[4],
                        foreground = colors[5],
                        padding=0,
                        fontsize=20
                        ),
               widget.TextBox(
                       text=" VOL:",
                        foreground=colors[2],
                        background=colors[5],
                        padding = 0
                        ),
               widget.Volume(
                        foreground = colors[2],
                        background = colors[5],
                        padding = 5
                        ),
               widget.TextBox(
                        text=u'\uE0B2',
                        background = colors[5],
                        foreground = colors[4],
                        padding=0,
                        fontsize=20
                        ),
               widget.CurrentLayoutIcon(
                        custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                        foreground = colors[0],
                        background = colors[4],
                        padding = 0,
                        scale=0.7
                        ),
               widget.CurrentLayout(
                        foreground = colors[2],
                        background = colors[4],
                        padding = 5
                        ),
               widget.TextBox(
                        text=u'\uE0B2',
                        background = colors[4],
                        foreground = colors[5],
                        padding=0,
                        fontsize=19
                        ),
               widget.Clock(
                        foreground = colors[2],
                        background = colors[5],
                        format="%A, %B %d %H:%M:%S "
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 10,
                        foreground = colors[0],
                        background = colors[5]
                        )
              ]
    else:
        widgets_list = [
               widget.Sep(
                        linewidth = 0,
                        padding = 6,
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.GroupBox(font="Deja Vu Sans Mono",
                        fontsize = 9,
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
                        background = colors[0],
                        visible_groups=visible_groups
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
                        text=u'\uE0B2',
                        background = colors[0],
                        foreground = colors[5],
                        padding=0,
                        fontsize=20
                        ),
               widget.TextBox(
                       text=" VOL:",
                        foreground=colors[2],
                        background=colors[5],
                        padding = 0
                        ),
               widget.Volume(
                        foreground = colors[2],
                        background = colors[5],
                        padding = 5
                        ),
               widget.TextBox(
                        text=u'\uE0B2',
                        background = colors[5],
                        foreground = colors[4],
                        padding=0,
                        fontsize=20
                        ),
               widget.CurrentLayoutIcon(
                        custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                        foreground = colors[0],
                        background = colors[4],
                        padding = 0,
                        scale=0.7
                        ),
               widget.CurrentLayout(
                        foreground = colors[2],
                        background = colors[4],
                        padding = 5
                        ),
               widget.TextBox(
                        text=u'\uE0B2',
                        background = colors[4],
                        foreground = colors[5],
                        padding=0,
                        fontsize=20
                        ),
               widget.Clock(
                        foreground = colors[2],
                        background = colors[5],
                        format="%A, %B %d %H:%M:%S "
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 10,
                        foreground = colors[0],
                        background = colors[5]
                        )
              ]
    return widgets_list

##### SCREENS ##### (TRIPLE MONITOR SETUP)

def init_widgets_screen1(visible_groups, type_screen):
    widgets_screen1 = init_widgets_list(visible_groups, type_screen)
    return widgets_screen1                       # Slicing removes unwanted widgets on Monitors 1,3

def init_widgets_screen2(visible_groups, type_screen):
    widgets_screen2 = init_widgets_list(visible_groups, type_screen)
    return widgets_screen2                       # Monitor 2 will display all widgets in widgets_list

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen2(["1: Editor", "2: Chrome", "5: Spotify", "8"], 0), opacity=1, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(["4: Discord", "7"], 1), opacity=1, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(["3: Terminals", "6: Email", "9"], 1), opacity=1, size=20))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

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
