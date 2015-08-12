require 'test_helper'

class PupenextFormBuilderTest < ActiveSupport::TestCase
  setup do
    @template = Object.new
    @template.extend ActionView::Helpers::FormHelper
    @template.extend ActionView::Helpers::FormOptionsHelper
    @template.extend ActionView::Helpers::FormTagHelper
  end

  test 'should return html with empty values' do
    fiscal_year = FiscalYear.new
    builder = PupenextFormBuilder.new(fiscal_year.model_name.i18n_key, fiscal_year, @template, {})
    response = assets_file 'pupenext_date_field_no_values.html'

    assert_equal response, builder.pupenext_date_field(:tilikausi_alku)
  end

  test 'should return inputs with values' do
    fiscal_year = FiscalYear.first
    fiscal_year.tilikausi_alku = Date.parse('2015-01-01')
    builder = PupenextFormBuilder.new(fiscal_year.model_name.i18n_key, fiscal_year, @template, {})
    response = assets_file 'pupenext_date_field_values.html'

    assert_equal response, builder.pupenext_date_field(:tilikausi_alku)
  end

  test 'should return inputs with values and options' do
    fiscal_year = FiscalYear.first
    fiscal_year.tilikausi_alku = Date.parse('2015-01-01')
    builder = PupenextFormBuilder.new(fiscal_year.model_name.i18n_key, fiscal_year, @template, {})
    response = assets_file 'pupenext_date_field_values_options.html'

    assert_equal response, builder.pupenext_date_field(:tilikausi_alku, class: 'woohoo', size: 15)
  end
end
