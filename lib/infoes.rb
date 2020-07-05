# infoes is a reader that aims to combine multiple services

require 'launchy'

require 'infoes/date_time_comparable'
require 'infoes/yaml_settings'
require 'infoes/rss_entry'
require 'infoes/rss_feeds'
require 'infoes/tweet'
require 'infoes/twitter_connection'
require 'infoes/settings'
require 'infoes/side_tab'

require 'infoes/tabs/about'
require 'infoes/tabs/general_settings'
require 'infoes/tabs/home'
require 'infoes/tabs/rss_settings'
require 'infoes/tabs/twitter_settings'


MENU_WIDTH = 120

# the main menu displayed on the left hand side
# opens the specified content in the main window
# find the corresponding classes in the tabs directory
def menu
  stack width: MENU_WIDTH do
    para link("Home") { open_tab(Infoes::Home) }
    para link("Twitter Settings") { open_tab(Infoes::TwitterSettings) }
    para link("RSS feed Settings") { open_tab(Infoes::RSSSettings) }
    para link("General Settings") { open_tab(Infoes::GeneralSettings) }
    para link("About") { open_tab(Infoes::About) }
    para link("Close") { close if confirm "Are you sure?" }
  end
end

def get_tab(tab_class)
  if @loaded_tabs.include?(tab_class)
    return @loaded_tabs[tab_class]
  else
    # load the class responding to the symbol(the desired tab)
    # the class could also be required just here, what do you think?
    # (gently stolen/adapted from the hacketyhack code)
    @loaded_tabs[tab_class] = tab_class.new(@main_content)
  end
end

def open_tab(symbol)
  @current_tab.close unless @current_tab.nil?
  @current_tab = get_tab(symbol)
  @current_tab.open
end

# main infoes app
Shoes.app(
  title: "infoes",
  width: Infoes::Settings.width,
  height: Infoes::Settings.height
) do
  background Infoes::Settings.color
  @loaded_tabs = {}
  title "This is infoes!", :align => "center"
  flow do
    menu
    @main_content = stack width: -MENU_WIDTH
  end

  # we start at home!
  open_tab(Infoes::Home)
end
