require 'rails_helper'

RSpec.describe 'homepages/show', type: :view do
  before(:each) do
    @homepage = assign(:homepage, Homepage.create!(
                                    abbrev: 'Abbrev',
                                    mitglnr: 'Mitglnr',
                                    name: 'Name',
                                    kontakt: 'Kontakt',
                                    proben: 'Proben',
                                    descr: 'Descr',
                                    redir_url: 'Redir Url'
                                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Abbrev/)
    expect(rendered).to match(/Mitglnr/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Kontakt/)
    expect(rendered).to match(/Proben/)
    expect(rendered).to match(/Descr/)
    expect(rendered).to match(/Redir Url/)
  end
end
