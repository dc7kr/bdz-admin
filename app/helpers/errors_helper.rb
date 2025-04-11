module ErrorsHelper
  def filter_backtrace(bt)
    bt.grep_v(/.bundle/).join("\n")
  end
end
