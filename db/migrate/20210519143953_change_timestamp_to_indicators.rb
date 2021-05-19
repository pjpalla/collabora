class ChangeTimestampToIndicators < ActiveRecord::Migration
  def change
      change_column_null :indicators, :created_at, true
      change_column_null :indicators, :updated_at, true
  end
end
