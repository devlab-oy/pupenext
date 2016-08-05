require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  fixtures %w(
    menus
  )

  test 'fixtures are valid' do
    refute_empty Menu.all

    Menu.all.each do |record|
      assert record.valid?, "Menu #{record.nimi}: #{record.errors.full_messages}"
    end
  end
end
