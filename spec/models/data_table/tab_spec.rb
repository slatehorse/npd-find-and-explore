# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataTable::Tab, type: :model do
  let(:concept) { build :concept }
  let(:workbook_path) { 'spec/fixtures/files/single_sheet_table.xlsx' }
  let(:workbook) { Roo::Spreadsheet.open(workbook_path) }
  let(:spreadsheet) { DataTable::Tab.new(workbook: workbook) }

  it 'Will extract the tab_name from table' do
    expect(spreadsheet.tab_name).to eq('Tab')
  end

  it 'Will extract the sheet from table' do
    expect(spreadsheet.sheet.class.name).to eq('Roo::Excelx::Sheet')
  end

  it 'Will load the file and create the Sheet object under 100ms' do
    expect {
      workbook = Roo::Spreadsheet.open(workbook_path)
      DataTable::Tab.new(workbook: workbook)
    }.to perform_under(100).ms.sample(10)
  end

  it 'Will preprocess under 500ms' do
    expect { spreadsheet.preprocess }
      .to perform_under(500).ms.sample(10)
  end
end