class Drug < ActiveRecord::Base
    before_create do
        self.created_at = " "
        self.updated_at = " "
    end
end
