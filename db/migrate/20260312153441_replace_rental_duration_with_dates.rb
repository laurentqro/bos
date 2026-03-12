class ReplaceRentalDurationWithDates < ActiveRecord::Migration[8.1]
  def up
    add_column :transactions, :rental_start_date, :date
    add_column :transactions, :rental_end_date, :date

    Transaction.where(transaction_type: "RENTAL").where.not(rental_duration_years: nil).find_each do |t|
      t.update_columns(
        rental_start_date: t.transaction_date,
        rental_end_date: t.transaction_date + t.rental_duration_years.years
      )
    end

    remove_column :transactions, :rental_duration_years, :integer
  end

  def down
    add_column :transactions, :rental_duration_years, :integer

    Transaction.where(transaction_type: "RENTAL").where.not(rental_start_date: nil).where.not(rental_end_date: nil).find_each do |t|
      years = ((t.rental_end_date - t.rental_start_date) / 365.25).round
      t.update_columns(rental_duration_years: years)
    end

    remove_column :transactions, :rental_start_date, :date
    remove_column :transactions, :rental_end_date, :date
  end
end
