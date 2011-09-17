require './tabs/side_tab'
require 'launchy'

class About < SideTab

  def content
    para "Infoes was created by me as I got sick of ",
      "having to check Twitter, my RSS Feeds and Facebook."
    para "And of course because Ruby makes me happy."
    para "If you don't know who to follow on Twitter, try ",
    # TODO: Why doesn't the method_missing magic work here?
      @slot.app.link("me") {
        Launchy.open("https://twitter.com/#!/PragTob")
      }, "."
    para "If you don't know which blog to follow, try ",
      @slot.app.link("my blog's RSS Feed") {
        # again {} necessary
        Launchy.open "http://pragtob.wordpress.com/feed/"
      } , "."
  end

end

