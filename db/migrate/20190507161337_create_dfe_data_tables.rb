# frozen_string_literal: true

class CreateDfEDataTables < ActiveRecord::Migration[5.2]
  def change
    create_table :dfe_data_tables, id: :uuid do |t|
      t.string     :file_name
      t.belongs_to :admin_user, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
