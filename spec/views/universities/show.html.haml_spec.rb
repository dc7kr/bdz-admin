require 'rails_helper'

RSpec.describe 'universities/show', type: :view do
  before(:each) do
    @university = assign(:university, University.create!(
                                        name: 'Name',
                                        institut: 'Institut',
                                        strasse: 'Strasse',
                                        plz: 'Plz',
                                        ort: 'Ort',
                                        land_id: 1,
                                        telefon: 'Telefon',
                                        studiengang: 'Studiengang',
                                        dozent: 'Dozent',
                                        email: 'Email',
                                        homepage: 'Homepage',
                                        country_code: 'Country Code'
                                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Institut/)
    expect(rendered).to match(/Strasse/)
    expect(rendered).to match(/Plz/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Telefon/)
    expect(rendered).to match(/Studiengang/)
    expect(rendered).to match(/Dozent/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Homepage/)
    expect(rendered).to match(/Country Code/)
  end
end
