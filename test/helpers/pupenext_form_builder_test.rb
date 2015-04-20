require 'test_helper'

class PupenextFormBuilderTest < ActiveSupport::TestCase
  test 'should return inputs with empty values' do
    template = Object.new
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::FormOptionsHelper
    template.extend ActionView::Helpers::FormTagHelper

    fiscal_year = FiscalYear.first
    builder     = PupenextFormBuilder.new(fiscal_year.model_name.i18n_key, fiscal_year, template, {})

    assert_equal expected_html, builder.pupenext_date_field(:tilikausi_alku)
  end

  def expected_html
    '<input type="text" name="fiscal_year[tilikausi_alku(3i)]" id="fiscal_year_tilikausi_alku_3i_" value="1" size="3" /> ' +
      '<input type="text" name="fiscal_year[tilikausi_alku(2i)]" id="fiscal_year_tilikausi_alku_2i_" value="1" size="3" /> ' +
      '<input type="text" name="fiscal_year[tilikausi_alku(1i)]" id="fiscal_year_tilikausi_alku_1i_" value="2015" size="5" />'
  end
end
