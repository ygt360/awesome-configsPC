-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Dynamic taggin library
require("shifty")
-- Scratchpad manager
require("scratch")
-- Widget library
require("vicious")

-- {{{ Variable definitions
local exec = awful.util.spawn

-- Themes define colours, icons, and wallpapers
beautiful.init("/home/zeiss/.config/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Alias
--GTDinbox = terminal .. " -e vim ~/Documentos/test"
--r@next='vim ~/Documentos/txt/@nextactions'
--r@projects='vim ~/Documentos/txt/@projects'
--r@someday='vim ~/Documentos/txt/@someday'
--r@tech='vim ~/Documentos/txt/@tech'
--r@online='vim ~/Documentos/txt/@online'
--r@waiting='vim ~/Documentos/txt/@waiting'
--r@check='vim ~/Documentos/txt/@checklist'

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Shifty predefined tags
shifty.config.tags = {
    ["1:term"] = { position = 1, init = true, layout = awful.layout.suit.tile      },
     ["2:web"] = { position = 2, exclusive = true, max_clients = 1, layout = awful.layout.suit.max  },
       ["3:✉"] = { position = 3, exclusive = true },
   ["4:media"] = { position = 4, exclusive = true, layout = awful.layout.suit.floating, persist = true  },
       ["5:λ"] = { position = 5, exclusive = true },
     ["6:dev"] = { position = 6, exclusive = true },
       ["7:✎"] = { position = 7, exclusive = true },
   ["8:files"] = { position = 8, persist = true },
    ["9:Misc"] = { position = 9, max_clients = 1, layout = awful.layout.suit.fair 
--run = function() exec(terminal) end, 
                 },
}
-- }}}

-- {{{ Shifty tags matching and client rules
shifty.config.apps = {
   { match = { "urxvt"                                  }, intrusive  = true             },
   { match = { "Namoroka", "opera", "luakit"            }, tag = "2:web", nopopup = true },
   { match = { "newsbeuter", "emesene", "irssi"         }, tag = "3:✉"                   },
   { match = { "Python Shell",                          }, tag = "6:dev"                 },
   { match = { "MPlayer", "vlc", "mirage", "gpicview"   }, tag = "4:media"               },
   { match = { "evince", "libreoffice", "lyx", "xchm"   }, tag = "7:✎"                   },
   { match = { "mc", "thunar"                           }, tag = "8:files"               },
   { match = { "keepassx", "brasero",                   }, tag = "9:Misc"                },
   { match = { "" }, 
           buttons = awful.util.table.join (
           awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
           awful.button({ modkey }, 1, awful.mouse.client.move),
           awful.button({ modkey }, 3, awful.mouse.client.resize))
   },
}
-- }}}

-- {{{ Shifty defaults
shifty.config.defaults = {
  layout = awful.layout.suit.tile,
  run = function(tag)  
  naughty.notify({ text = "Shifty Created "..
		 (awful.tag.getproperty(tag,"position") or shifty.tag2index(mouse.screen,tag)).." : "..
		 (tag.name or "foo")
	 	  }) end,
  guess_name = true,
  persist = false,
  leave_kills = false,
  exclusive = false,
  guess_position = true,
  remember_index = true,
  ncol = 1,
  floatBars=true,
  mwfact = 0.5,
  nopopup = true
}
shifty.config.default_name = "?"
shifty.init()
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox

-- {{{ Separator widget
-- Initialize widget
separator = widget({ type = "imagebox" })
-- Icons
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ CPU usage and temperature
-- Initialize cpu0
cpu0graph  = awful.widget.graph()
-- Graph properties cpu0
cpu0graph:set_width(40):set_height(16)
cpu0graph:set_background_color(beautiful.fg_off_widget)
cpu0graph:set_gradient_angle(0):set_gradient_colors({ beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget })
-- Register cpu0
vicious.register(cpu0graph,  vicious.widgets.cpu,      "$2")
-- cpu0 %
cpu0 = widget({ type = "textbox" })
vicious.register(cpu0, vicious.widgets.cpu, "$2%", 2)
-- Initialize cpu1
cpu1graph  = awful.widget.graph()
-- Graph properties cpu1
cpu1graph:set_width(40):set_height(16)
cpu1graph:set_background_color(beautiful.fg_off_widget)
cpu1graph:set_gradient_angle(0):set_gradient_colors({ beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget })
-- Register cpu1
vicious.register(cpu1graph,  vicious.widgets.cpu,      "$3")
-- cpu1 %
cpu1 = widget({ type = "textbox" })
vicious.register(cpu1, vicious.widgets.cpu, "$2%", 2)
-- Icons
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- }}}

-- {{{ Memory widget
-- Initialize widget
memwidget = widget({ type = 'textbox' })
vicious.cache(vicious.widgets.mem)
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$2MB", 13)
-- Icons
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- }}}

-- {{{ Network usage widget
-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${lan0 down_kb}</span> <span color="#7F9F7F">${lan0 up_kb}</span>', 2)
-- Icons
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
-- }}}

-- {{{ File system usage
-- Initialize widget
--fs.h = widget({ type = "textbox" })
--vicious.cache(vicious.widgets.fs)
-- Register widget
--vicious.register(homewidget, vicious.widget.fs, "${/home used_p}", 599)
--vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)
-- }}}

-- {{{ Volume level widget
-- Initialize widgets
volwidget = widget({ type = "textbox" })
-- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volwidget, vicious.widgets.volume, "$1%", 2, "PCM")
-- Icons
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- }}}

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
-- taglist
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
shifty.taglist = mytaglist
-- tasklist
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mylayoutbox[s],
			separator,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mytextclock,
        separator, volwidget, volicon,
--		separator, homewidget,
        separator, upicon, netwidget, dnicon,
        separator, memwidget, memicon,
        separator, cpu1graph.widget, cpuicon, cpu0graph.widget, cpuicon,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- shifty keybindings
    awful.key({                   }, "XF86Back",    awful.tag.viewprev),
    awful.key({                   }, "XF86Forward", awful.tag.viewnext),
    awful.key({ modkey,           }, "XF86Back",    shifty.shift_prev),
    awful.key({ modkey,           }, "XF86Forward", shifty.shift_next),
    awful.key({ modkey,           }, "t",           function() shifty.add({ rel_index = 1 }) end, nil, "new tag"),
    awful.key({ modkey, "Control" }, "t",           function() shifty.add({ rel_index = 1, nopopup = true }) end),
    awful.key({ modkey,           }, "z",           shifty.rename, nil, "tag rename"),
    awful.key({ modkey,           }, "d",           shifty.del, nil, "tag delete"),

    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Custom keybindgs
    awful.key({ modkey,           }, "F2", function () exec("opera") end),
    awful.key({ modkey, "Shift"   }, "F2", function () exec("firefox") end),
    awful.key({ modkey,           }, "F3", function () exec(terminal .. " -e newsbeuter") end),
    awful.key({ modkey, "Shift"   }, "F3", function () exec("emesene") end),
    awful.key({ modkey,           }, "F4", function () exec("vlc") end),
    awful.key({ modkey,           }, "F8", function () exec("thunar") end),
    awful.key({ modkey, "Shift"   }, "F8", function () exec(terminal ..  " -e mc") end),
    awful.key({ modkey,           }, "p",  function() awful.util.spawn( "dmenu_run" ) end),
    awful.key({ modkey,           }, ".",  function () exec("amixer -q set PCM 2dB+") end),
    awful.key({ modkey,           }, ",",  function () exec("amixer -q set PCM 2dB-") end),
    awful.key({ modkey,           }, "Print",  function () exec("scrot -e 'mv $f ~/Screenshots/ 2>/dev/null'") end),
    awful.key({ modkey, "Control" }, "l",      function () exec("slock") end),

    -- Scratchpad
    awful.key({ modkey,           }, "s", function () scratch.pad.toggle() end),
    awful.key({ modkey,           }, "`", function () scratch.drop(terminal, "top") end),
    awful.key({ modkey,           }, "a", function () scratch.drop(terminal .. " -e mocp", "bottom", "center", 0.60, 0.40, true ) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "s",      function (c) scratch.pad.set(c, 0.60, 0.60, true) end),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Workspaces
-- Shifty:
for i=1,9 do
  
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey }, i,
  function ()
    local t = awful.tag.viewonly(shifty.getpos(i))
  end))
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control" }, i,
  function ()
    local t = shifty.getpos(i)
    t.selected = not t.selected
  end))
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control", "Shift" }, i,
  function ()
    if client.focus then
      awful.client.toggletag(shifty.getpos(i))
    end
  end))
  -- move clients to other tags
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Shift" }, i,
    function ()
      if client.focus then
        local t = shifty.getpos(i)
        awful.client.movetotag(t)
        awful.tag.viewonly(t)
      end
    end))
end

-- Set keys
root.keys(globalkeys)
shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- To Do
-- Seguir mirando config jackH79, buscando mejoras
-- Cambiar default theme
-- Agregar widgets vicious (CPU, RAM, Network, Volume, etc)
-- Agregar nuevas global keys (opera, firefox, etc)
-- Seguir configurando a apps match
