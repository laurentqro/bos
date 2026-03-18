class AddNonFaceToFaceOnboardingToClients < ActiveRecord::Migration[8.1]
  def change
    add_column :clients, :non_face_to_face_onboarding, :boolean, default: false, null: false
  end
end
