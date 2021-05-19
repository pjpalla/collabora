class ChangeTimestampToSurveys < ActiveRecord::Migration
  def change
    change_column_null :surveys, :created_at, true
    change_column_null :surveys, :updated_at, true
  end
end
