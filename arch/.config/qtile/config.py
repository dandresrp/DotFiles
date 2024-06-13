from libqtile import bar, layout, widget, hook
from libqtile.config import EzClick as Click, EzDrag as Drag, Group, ScratchPad, DropDown, EzKey as Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import os
import subprocess

@hook.subscribe.startup_once
def start():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([script])

mod = "mod4"
terminal = "alacritty"
browser = "firefox"
files = "pcmanfm"
prompt = "rofi -show run"

keys = [
    # Switch between windows
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key("M-S-<Return>", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),
    Key("M-e", lazy.spawn(files), desc="Launch file manager"),
    Key("M-b", lazy.spawn(browser), desc="Launch web browser"),
    Key("M-p", lazy.spawn(prompt), desc="Launch prompt"),
    Key("M-s", lazy.spawn("flameshot full -c"), desc="Take screenshot of fullscreen"),
    Key("M-S-s", lazy.spawn("flameshot gui -c -s"), desc="Take screenshot of selected region"),
    Key("M-S-C-s", lazy.spawn("flameshot gui -c"), desc="Take screenshot of selected region and open editor"),
    Key("<F10>", lazy.group['scratchpad'].dropdown_toggle('volume')),
    Key("<F11>", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key("<F12>", lazy.group['scratchpad'].dropdown_toggle('music')),

    # Toggle between different layouts as defined below
    Key("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    Key("M-S-c", lazy.window.kill(), desc="Kill focused window"),
    Key("M-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
    Key("M-t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key("M-C-r", lazy.reload_config(), desc="Reload the config"),
    Key("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key("M-r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

groups = [
        ScratchPad("scratchpad", [
            DropDown("volume", "pavucontrol", height=0.3, width=0.3, x=0.35, y=0.30, opacity=1.0),
            DropDown("term", "alacritty", height=0.7, width=0.5, x=0.25, y=0.15, opacity=1.0),
            DropDown("music", "spotify", height=0.7, width=0.5, x=0.25, y=0.15, opacity=1.0),
            ]),
        ]
group_names = [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
group_layouts = [ "columns", "columns", "columns", "columns", "columns", "columns", "columns", "columns", "columns" ]
group_labels = [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]

for i in range(9):
    groups.append(
        Group(
            name = group_names[i],
            layout = group_layouts[i].lower(),
            label = group_labels[i]
        ))

for j in range(9):
    keys.extend(
        [
            Key("M-"+str(j+1), lazy.group[group_names[j]].toscreen(), desc="Switch to group {}".format(group_names[j])),
            Key("M-S-"+str(j+1), lazy.window.togroup(group_names[j], switch_group=False), desc="Switch to & move focused window to group {}".format(group_names[j])),
        ]
    )

layouts = [
    layout.Columns(
        insert_position=1,
        margin=4,
        margin_on_single=0,
        border_focus="#88898a",
        border_width=2,
        ),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="UbuntuMono Nerd Font",
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(filename='~/.config/qtile/qtile-logo.png', margin=4),
                widget.GroupBox(),
                #widget.TaskList(),
                widget.Spacer(),
                # widget.WindowName(),
                widget.Clock(format="%a %d %H:%M %p"),
                widget.Spacer(),
                # widget.WidgetBox(close_button_location='right', widgets=[widget.Systray()]),
                widget.Systray()
                # widget.Clock(format="%d-%m-%Y %a %I:%M %p"),
                # widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag("M-1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="Ristretto"),
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="Variety Images"),
        Match(title="Friends List"),
    ],
    border_focus="#88898a",
    border_width=2,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
