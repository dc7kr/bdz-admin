class Tariff < ApplicationRecord
  def calcLvPart
    amount * BDZ_SETTINGS['tariff']['lvPart']
  end
end
