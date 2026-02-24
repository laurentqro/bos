class NullifyEmptyStringCountryFields < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE clients SET nationality = NULL WHERE nationality = '';
      UPDATE clients SET residence_country = NULL WHERE residence_country = '';
      UPDATE beneficial_owners SET nationality = NULL WHERE nationality = '';
      UPDATE beneficial_owners SET residence_country = NULL WHERE residence_country = '';
      UPDATE transactions SET property_country = NULL WHERE property_country = '';
      UPDATE managed_properties SET tenant_country = NULL WHERE tenant_country = '';
      UPDATE organizations SET country = NULL WHERE country = '';
    SQL
  end

  def down
    # No-op: we cannot restore the original empty strings
  end
end
