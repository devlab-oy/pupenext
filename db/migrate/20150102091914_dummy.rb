class Dummy < ActiveRecord::Migration
  def change
    # we need one dummy migration for now.
    # otherwise tests will do full schema reload before every test.
  end
end
