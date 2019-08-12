class AddOtherColumnsToIndicator < ActiveRecord::Migration
  def change
    add_column :indicators, :i8_1, :integer
    add_column :indicators, :i8_2, :integer
    add_column :indicators, :i8_3, :integer
    add_column :indicators, :i8_4, :integer
    add_column :indicators, :i8_5, :integer
    add_column :indicators, :i8_6, :integer
  end
end
