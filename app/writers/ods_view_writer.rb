require 'rodf'

class OdsViewWriter
  attr_accessor :view_name, :data

  def initialize(data, view_name)
    self.view_name = view_name
    self.data = data
  end

  def write(tmpfile)
    table_name = view_name
    data = self.data
    RODF::Spreadsheet.file(tmpfile.path) do
      table table_name do |t|
        t.row do
          data.columns.each do |c|
            cell c.to_s
          end
        end

        data.rows.each do |r|
          t.row do
            r.each do |c|
              cell c.to_s
            end
          end
        end
      end
    end
  end
end
