# frozen_string_literal: true

class UpdateNoConceptDescription < ActiveRecord::Migration[5.2]
  def up
    Concept.find_by(name: 'No Concept')
           &.update(description: 'This Concept is used to house data elements that are waiting to be categorised')
  end

  def down
    # nothing to do
  end
end