# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfArch::Upload, type: :model do
  let(:admin_user) { create :admin_user }
  let(:table_path) { 'spec/fixtures/files/categories_table.xlsx' }
  let(:loader) do
    InfArch::Upload.new(admin_user: admin_user,
                        file_name: 'categories_table.xlsx',
                        data_table: table_path)
  end
  let(:de_table_path) { 'spec/fixtures/files/reduced_table.xlsx' }
  let(:de_loader) do
    DataTable::Upload.new(admin_user: admin_user,
                          file_name: 'reduced_table.xlsx',
                          data_table: de_table_path)
  end

  it 'Will preprocess under 800ms' do
    expect { loader.preprocess }
      .to perform_under(800).ms.sample(10)
  end

  it 'Will preprocess the infrastructure architecture items' do
    expect { loader.preprocess }
      .to change(InfArch::Upload, :count).by(1)
      .and change(InfArch::Tab, :count).by(4)
  end

  it 'Will process within 200ms' do
    loader.preprocess
    expect { loader.process }
      .to perform_under(200).ms.sample(10)
  end

  it 'Will process the categories and concepts' do
    loader.preprocess
    expect { loader.process }
      .to change(Category, :count).by(172)
      .and change(Concept, :count).by(2233)
  end

  it 'Will assign a real concept to data elements' do
    de_loader.preprocess
    de_loader.process

    data_element = DataElement.find_by(npd_alias: 'KS4_ACTYRGRP')
    no_concept = Concept.find_by(name: 'No Concept')
    expect(no_concept.data_elements.count).to eq(274)
    expect(data_element.concept).to eq(no_concept)

    loader.preprocess
    loader.process
    new_concept = Concept.find_by(name: 'Actual year group')

    expect(no_concept.data_elements.count).to eq(57) # fix when the new IA tables are done
    expect(data_element.reload.concept).to eq(new_concept)
  end
end
