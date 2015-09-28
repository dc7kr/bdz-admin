require 'rails_helper'

RSpec.describe "orchestras/edit", :type => :view do
  before(:each) do
    @orchestra = assign(:orchestra, Orchestra.create!(
      :mglnr => 1,
      :orchName => "MyString",
      :anrede => "MyString",
      :vorname => "MyString",
      :nachname => "MyString",
      :strasse => "MyString",
      :land => "MyString",
      :plz => "MyString",
      :ort => "MyString",
      :telefon => "MyString",
      :fax => "MyString",
      :za => "MyString",
      :konto => 1,
      :blz => 1,
      :lv_id => 1,
      :zw => "MyString",
      :zeitungen => 1,
      :gema => 1,
      :numBis14 => 1,
      :num15bis18 => 1,
      :num19bis27 => 1,
      :numUeber27 => 1,
      :sumMitglieder => 1,
      :azubi => 1,
      :passive => 1,
      :beitrag => "9.99",
      :unfallversicherung => false,
      :meldebogen => false,
      :rechnungsDruck => false,
      :koopMitglied => false,
      :uvBetrag => "9.99",
      :rechnungsbetrag => "9.99",
      :versaeumniszuschlag => false,
      :vZuschlag => "9.99",
      :mahngebuehr1 => false,
      :mahngebuehr2 => false,
      :mGebuehr1 => "9.99",
      :mGebuehr2 => "9.99",
      :bemerkung => "MyString",
      :eMail => "MyString",
      :url => "MyString",
      :lastschriftErfasst => false,
      :kuendigungErfasst => false,
      :zweitanschrift => "MyString",
      :name2 => "MyString",
      :dageVER => 1
    ))
  end

  it "renders the edit orchestra form" do
    render

    assert_select "form[action=?][method=?]", orchestra_path(@orchestra), "post" do

      assert_select "input#orchestra_mglnr[name=?]", "orchestra[mglnr]"

      assert_select "input#orchestra_orchName[name=?]", "orchestra[orchName]"

      assert_select "input#orchestra_anrede[name=?]", "orchestra[anrede]"

      assert_select "input#orchestra_vorname[name=?]", "orchestra[vorname]"

      assert_select "input#orchestra_nachname[name=?]", "orchestra[nachname]"

      assert_select "input#orchestra_strasse[name=?]", "orchestra[strasse]"

      assert_select "input#orchestra_land[name=?]", "orchestra[land]"

      assert_select "input#orchestra_plz[name=?]", "orchestra[plz]"

      assert_select "input#orchestra_ort[name=?]", "orchestra[ort]"

      assert_select "input#orchestra_telefon[name=?]", "orchestra[telefon]"

      assert_select "input#orchestra_fax[name=?]", "orchestra[fax]"

      assert_select "input#orchestra_za[name=?]", "orchestra[za]"

      assert_select "input#orchestra_konto[name=?]", "orchestra[konto]"

      assert_select "input#orchestra_blz[name=?]", "orchestra[blz]"

      assert_select "input#orchestra_lv_id[name=?]", "orchestra[lv_id]"

      assert_select "input#orchestra_zw[name=?]", "orchestra[zw]"

      assert_select "input#orchestra_zeitungen[name=?]", "orchestra[zeitungen]"

      assert_select "input#orchestra_gema[name=?]", "orchestra[gema]"

      assert_select "input#orchestra_numBis14[name=?]", "orchestra[numBis14]"

      assert_select "input#orchestra_num15bis18[name=?]", "orchestra[num15bis18]"

      assert_select "input#orchestra_num19bis27[name=?]", "orchestra[num19bis27]"

      assert_select "input#orchestra_numUeber27[name=?]", "orchestra[numUeber27]"

      assert_select "input#orchestra_sumMitglieder[name=?]", "orchestra[sumMitglieder]"

      assert_select "input#orchestra_azubi[name=?]", "orchestra[azubi]"

      assert_select "input#orchestra_passive[name=?]", "orchestra[passive]"

      assert_select "input#orchestra_beitrag[name=?]", "orchestra[beitrag]"

      assert_select "input#orchestra_unfallversicherung[name=?]", "orchestra[unfallversicherung]"

      assert_select "input#orchestra_meldebogen[name=?]", "orchestra[meldebogen]"

      assert_select "input#orchestra_rechnungsDruck[name=?]", "orchestra[rechnungsDruck]"

      assert_select "input#orchestra_koopMitglied[name=?]", "orchestra[koopMitglied]"

      assert_select "input#orchestra_uvBetrag[name=?]", "orchestra[uvBetrag]"

      assert_select "input#orchestra_rechnungsbetrag[name=?]", "orchestra[rechnungsbetrag]"

      assert_select "input#orchestra_versaeumniszuschlag[name=?]", "orchestra[versaeumniszuschlag]"

      assert_select "input#orchestra_vZuschlag[name=?]", "orchestra[vZuschlag]"

      assert_select "input#orchestra_mahngebuehr1[name=?]", "orchestra[mahngebuehr1]"

      assert_select "input#orchestra_mahngebuehr2[name=?]", "orchestra[mahngebuehr2]"

      assert_select "input#orchestra_mGebuehr1[name=?]", "orchestra[mGebuehr1]"

      assert_select "input#orchestra_mGebuehr2[name=?]", "orchestra[mGebuehr2]"

      assert_select "input#orchestra_bemerkung[name=?]", "orchestra[bemerkung]"

      assert_select "input#orchestra_eMail[name=?]", "orchestra[eMail]"

      assert_select "input#orchestra_url[name=?]", "orchestra[url]"

      assert_select "input#orchestra_lastschriftErfasst[name=?]", "orchestra[lastschriftErfasst]"

      assert_select "input#orchestra_kuendigungErfasst[name=?]", "orchestra[kuendigungErfasst]"

      assert_select "input#orchestra_zweitanschrift[name=?]", "orchestra[zweitanschrift]"

      assert_select "input#orchestra_name2[name=?]", "orchestra[name2]"

      assert_select "input#orchestra_dageVER[name=?]", "orchestra[dageVER]"
    end
  end
end
