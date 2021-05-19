class ChangeTimestampToDrugs < ActiveRecord::Migration
  def change
      def change
        change_column_null :drugs, :created_at, true
        change_column_null :drugs, :updated_at, true
      end
  end
end
