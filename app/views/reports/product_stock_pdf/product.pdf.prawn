text_box_params = {
  align:    :center,
  overflow: :shrink_to_fit,
  size:     300,
  valign:   :center,
}

prawn_document(page_layout: :landscape) do |pdf|
  # Piirretään axis helpperit development modessa
  # pdf.stroke_axis if Rails.env.development?

  # Tuotenumero laatikko
  pdf.draw_text 'TUOTENUMERO', at: [0, 480], size: 40
  pdf.bounding_box([0, 470], width: 770, height: 240) do
    pdf.stroke_bounds
    pdf.text_box @product.tuoteno, text_box_params
  end

  # Varastopaikka laatikko
  pdf.draw_text 'Varastopaikka', at: [0, 205], size: 30
  pdf.bounding_box([0, 195], width: 770, height: 80) do
    pdf.stroke_bounds
    pdf.text_box @product.shelf_locations.first.to_s, text_box_params
  end

  # Kpl laatikko
  pdf.draw_text 'KPL', at: [0, 85], size: 30
  pdf.bounding_box([0, 80], width: 380, height: 80) do
    pdf.stroke_bounds
    pdf.text_box @qty, text_box_params
  end

  # Pvm laatikko
  pdf.draw_text 'PVM', at: [390, 85], size: 30
  pdf.bounding_box([390, 80], width: 380, height: 80) do
    pdf.stroke_bounds
    pdf.text_box l(Time.zone.today), text_box_params
  end
end
