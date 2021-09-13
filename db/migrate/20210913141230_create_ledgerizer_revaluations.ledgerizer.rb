# This migration comes from ledgerizer (originally 20201006134238)
class CreateLedgerizerRevaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :ledgerizer_revaluations do |t|
      t.references :tenant, polymorphic: true
      t.string :currency
      t.datetime :revaluation_time
      t.monetize :amount, amount: { null: false, default: 0 }
    end

    safety_assured {
      change_column :ledgerizer_revaluations, :amount_cents, :integer, limit: 8
    }

    add_index(
      :ledgerizer_revaluations,
      [
        :tenant_id,
        :tenant_type,
        :revaluation_time,
        :currency,
      ],
      unique: true,
      name: 'unique_revaluations_index'
    )
  end
end
