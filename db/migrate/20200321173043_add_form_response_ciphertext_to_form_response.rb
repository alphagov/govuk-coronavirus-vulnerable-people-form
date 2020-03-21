class AddFormResponseCiphertextToFormResponse < ActiveRecord::Migration[6.0]
  def up
    change_table(:form_responses, bulk: true) do |t|
      t.text :form_response_ciphertext
      t.text :encrypted_kms_key
      t.remove :form_response
    end
  end
end
