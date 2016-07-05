require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  fixtures %w(
    campaigns
  )

  setup do
    @campaign = campaigns(:galna)
  end

  test 'fixtures are valid' do
    assert @campaign.valid?, @campaign.errors.full_messages
  end

  test 'relations work' do
    assert_equal @campaign.company, companies(:acme)
  end

  test 'scopes work' do
    assert_equal Campaign.count, Campaign.active.count
    @campaign.active = 0
    @campaign.save!

    assert_equal 0, Campaign.active.count
  end
end
