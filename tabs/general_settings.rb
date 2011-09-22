require_relative 'side_tab'
require_relative '../lib/settings'

class GeneralSettings < SideTab

  def content
    change_background_color
    change_reload_interval
  end

  private

  def change_background_color
    button "Change background color" do
      color = ask_color "What background color would you like?"
      if color
        Settings.color = color
      end
    end
  end

  def change_reload_interval
    para "Reload interval in minutes:"
    @interval_edit = edit_line(Settings.reload_interval / 60)
    button "Change reload interval" do
      Settings.reload_interval = @interval_edit.text.to_i
    end
  end

end

