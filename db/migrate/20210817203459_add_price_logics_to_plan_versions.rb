class AddPriceLogicsToPlanVersions < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured {
      add_reference :price_logics, :plan_version, foreign_key: true, index: false
      add_index :price_logics, :plan_version_id, algorithm: :concurrently
    }
  end
end
