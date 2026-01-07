module ErrorsHelper
  def filter_backtrace(bt)
    #bt.grep_v(/.bundle/).join(raw("<br>"))
    bt
  end
  def find_our_first(bt)
    bt.grep_v(/.bundle/)[0]
  end
end
