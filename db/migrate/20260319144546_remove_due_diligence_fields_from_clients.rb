class RemoveDueDiligenceFieldsFromClients < ActiveRecord::Migration[8.1]
  def change
    remove_index :clients, :due_diligence_level, name: "index_clients_on_due_diligence_level"
    remove_column :clients, :due_diligence_level, :string
    remove_column :clients, :simplified_dd_reason, :text
  end
end
