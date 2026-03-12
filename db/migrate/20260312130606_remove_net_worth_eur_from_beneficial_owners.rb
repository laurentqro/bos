class RemoveNetWorthEurFromBeneficialOwners < ActiveRecord::Migration[8.1]
  def change
    remove_column :beneficial_owners, :net_worth_eur, :decimal, precision: 15, scale: 2
  end
end
