class AddNetWorthRangeToBeneficialOwners < ActiveRecord::Migration[8.1]
  def change
    add_column :beneficial_owners, :net_worth_range, :string
  end
end
