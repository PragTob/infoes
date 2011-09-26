module Infoes
  class GeneralSettings < SideTab

    SMALL_EDIT_LINE_WIDTH = 60

    def content
      change_background_color
      change_reload_interval
      change_dimensions
    end

    private

    def change_background_color
      button "Change background color" do
        color = ask_color "What background color would you like?"
        if color
          Settings.color = color
          alert "Background color succesfully changed. " +
                "Change will take effect after restart."
        end
      end
    end

    def change_reload_interval
      flow do
        para "Reload interval in minutes:"
        @interval_edit = edit_line(Settings.reload_interval / 60,
          width: SMALL_EDIT_LINE_WIDTH)
        button "Change" do
          Settings.reload_interval = @interval_edit.text
          alert "Reload interval succesfully changed"
        end
      end
    end

    def change_dimensions
      para "Window dimensions"
      flow do
        para "Width: "
        @width_edit = edit_line(Settings.width, width: SMALL_EDIT_LINE_WIDTH)
        para "Height: "
        @height_edit = edit_line(Settings.height, width: SMALL_EDIT_LINE_WIDTH)
        button "Change" do
          Settings.new_dimensions(@width_edit.text, @height_edit.text)
          alert "Windows dimensions succesfully changed! " +
                "Change will take effect after restart."
        end
      end
    end

  end
end

