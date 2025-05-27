class Prices
  # fees
  def self.mgebuehr1
    BDZ_SETTINGS["fees"]["mgebuehr1"]
  end

  def self.mgebuehr2
    BDZ_SETTINGS["fees"]["mgebuehr2"]
  end

  def self.delayFee
    BDZ_SETTINGS["fees"]["saeumnis_zuschlag"]
  end

  # distinctions
  def self.certificate
    BDZ_SETTINGS["distinction_prices"]["certificate"].to_f
  end

  def self.silverNeedle
    BDZ_SETTINGS["distinction_prices"]["silverneedle"].to_f
  end

  def self.goldenNeedle
    BDZ_SETTINGS["distinction_prices"]["goldenneedle"].to_f
  end

  def self.nationalNeedle
    BDZ_SETTINGS["distinction_prices"]["nationalneedle"].to_f
  end

  def self.medal
    BDZ_SETTINGS["distinction_prices"]["medal"].to_f
  end

  def self.honorLetter
    BDZ_SETTINGS["distinction_prices"]["honorletter"].to_f
  end

  def self.distinctionPorto
    BDZ_SETTINGS["distinction_prices"]["porto"].to_f
  end

  # beitraege
  def self.childrenRate
    BDZ_SETTINGS["tariff"]["childrenRate"].to_f
  end

  def self.teensRate
    BDZ_SETTINGS["tariff"]["teensRate"].to_f
  end

  def self.youthRate
    BDZ_SETTINGS["tariff"]["youthRate"].to_f
  end

  def self.adultRate
    BDZ_SETTINGS["tariff"]["adultRate"].to_f
  end

  def self.seniorRate
    BDZ_SETTINGS["tariff"]["adultRate"].to_f
  end

  def self.uvRate
    BDZ_SETTINGS["tariff"]["uvRate"].to_f
  end

  def self.minTariff
    BDZ_SETTINGS["tariff"]["minBeitrag"].to_f
  end

  def self.maxTariff
    BDZ_SETTINGS["tariff"]["maxBeitrag"].to_f
  end

  def self.zeitung
    BDZ_SETTINGS["tariff"]["zeitung"].to_f
  end

  def self.uvRate
    BDZ_SETTINGS["tariff"]["uv"].to_f
  end

  def self.hvLvRate
    BDZ_SETTINGS["tariff"]["hvgebuehrLv"].to_f
  end

  def self.lvOrchRate
    BDZ_SETTINGS["tariff"]["lvOrch"].to_f
  end

  def self.lvMember
    BDZ_SETTINGS["tariff"]["lvMember"].to_f
  end

  def self.coopRate
    BDZ_SETTINGS["tariff"]["coopOrch"].to_f
  end

  def self.foreignCoopRate
    BDZ_SETTINGS["tariff"]["foreign_coop"].to_f
  end

  def self.ztgRate
    BDZ_SETTINGS["tariff"]["ztgRate"].to_f
  end

  def self.loZtgCount
    BDZ_SETTINGS["tariff"]["loZtgCount"].to_i
  end
end
