require 'test_helper'

# Create dummy class for testing Searchable concern using yhtio -table
class DummyClass < ActiveRecord::Base
  include Searchable
  has_many :products, foreign_key: :yhtio, primary_key: :yhtio
  self.table_name = :yhtio
end

class DumberClass < ActiveRecord::Base
  include Searchable
  self.table_name = :yhtion_parametrit
end

class SearchableTest < ActiveSupport::TestCase

  fixtures %w(products)

  test 'should search using relations' do
    assert_equal 1, DummyClass.joins(:products).where_like("tuote.tuoteno", "hammer123").count
  end

  test 'should fail searching with invalid column syntax' do
    assert_raises ArgumentError do
      DummyClass.joins(:products).where_like("tuote.vasara.tuoteno", "hammer123")
    end
  end

  test 'test where_like search' do
    assert_equal 1, DummyClass.where_like(:yhtio, 'acme').count
    assert_equal 2, DummyClass.where_like(:nimi, 'orporati').count
    assert_equal 1, DummyClass.where_like('maa', 'EE').count
    assert_equal 0, DummyClass.where_like('yhtio', 'not_found').count
  end

  test 'test search_like search parameters' do
    assert_raises(ArgumentError) { DummyClass.search_like("string") }
    assert_nothing_raised { DummyClass.search_like( {} ) }
  end

  test 'test search_like exact search' do
    assert_equal 1, DummyClass.search_like(nimi: 'Estonian').count, 'like match should return 1'
    assert_equal 0, DummyClass.search_like(nimi: '@estonian').count, '@ char should do exact match'
    assert_equal 1, DummyClass.search_like(nimi: '@estonian corporation').count

    args = {
      nimi: '@estonian corporation',
      yhtio: 'esto'
    }

    assert_equal 1, DummyClass.search_like(args).count, "multiple hashes do AND query"
  end

  test 'search like multiple keywords' do
    params = { nimi: 'acm', muuttaja: 'jo' }
    assert_equal 1, DummyClass.search_like(params).count

    params = { nimi: 'acm', muuttaja: 'johanna' }
    assert_equal 0, DummyClass.search_like(params).count

    params = { "tuote.tuoteno" => "hammer123", "tuote.tuotemerkki" => "bosch" }
    assert_equal 1, DummyClass.joins(:products).search_like(params).count

    params = { "tuote.tuoteno" => "hammer123", "tuote.tuotemerkki" => "not_bosch" }
    assert_equal 0, DummyClass.joins(:products).search_like(params).count
  end

  test 'should be able to search with db date' do
    params = { tilikausi_alku: '2012-01-01' }

    assert_equal 1, DummyClass.search_like(params).count
  end

  test 'should be able to search with true and false' do
    count = DumberClass.all.count

    # Mark all false
    DumberClass.update_all(lapsituotteen_poiston_esto: false)

    params = { lapsituotteen_poiston_esto: 'false' }
    assert_equal count, DumberClass.search_like(params).count

    params = { lapsituotteen_poiston_esto: 'true' }
    assert_equal 0, DumberClass.search_like(params).count

    # Mark all true
    DumberClass.update_all(lapsituotteen_poiston_esto: true)

    params = { lapsituotteen_poiston_esto: 'false' }
    assert_equal 0, DumberClass.search_like(params).count

    params = { lapsituotteen_poiston_esto: 'true' }
    assert_equal count, DumberClass.search_like(params).count
  end

  test 'works with enum values' do
    IncomingMail.delete_all

    IncomingMail.new(status: 'ok').save(validate: false)
    IncomingMail.new(status: 'error').save(validate: false)
    IncomingMail.new.save(validate: false)

    assert_equal 1, IncomingMail.search_like(status: 'ok').count
    assert_equal 1, IncomingMail.search_like(status: 'error').count
  end

  test 'numeric search' do
    params = { tullikamari: 1 }

    company = DummyClass.search_like(params).first

    assert_equal "esto", company.yhtio
  end
end
