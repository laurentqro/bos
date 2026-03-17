class AddPreemptedByStateToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :preempted_by_state, :boolean, default: false
  end
end
