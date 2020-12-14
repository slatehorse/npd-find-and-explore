# frozen_string_literal: true

module DataTable
  class Upload < ApplicationRecord
    include DataElementImport
    include ProcessUpload

    default_scope { order(created_at: :asc) }

    belongs_to :admin_user, inverse_of: :data_table_uploads, optional: true
    has_many :data_table_tabs,
             class_name: 'DataTable::Tab', foreign_key: :data_table_upload_id,
             inverse_of: :data_table_upload, dependent: :destroy
    has_many :data_table_rows,
             class_name: 'DataTable::Row', foreign_key: :data_table_upload_id,
             inverse_of: :data_table_upload, dependent: :destroy

    has_one_attached :data_table

    attr_accessor :workbook

    def initialize(attr)
      @workbook = Roo::Spreadsheet.open(attr.delete(:data_table))
      super(attr)
    end

    def new_rows
      DataTable::Row.where('data_table_upload_id = ? AND unique_alias NOT IN (SELECT unique_alias FROM data_elements)', id)
    end

    def del_rows
      DataElement.where('unique_alias NOT IN (SELECT unique_alias FROM data_table_rows WHERE data_table_upload_id = ?)', id)
    end

    def del_datasets
      invalid_tabs = DataTable::Tab.where('data_table_upload_id = ? AND process_warnings IS NOT NULL AND ' \
                                          'json_array_length(process_warnings) > 0', id).pluck(:dataset_id)
      Dataset.where(id: invalid_tabs)
    end
  end
end
