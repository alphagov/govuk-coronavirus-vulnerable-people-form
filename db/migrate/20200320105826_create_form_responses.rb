# frozen_string_literal: true

class CreateFormResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :form_responses do |t|
      t.jsonb :form_response, default: {}, null: false
      t.datetime :created_at, null: false
    end
  end
end
