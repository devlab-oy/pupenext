$(document).on 'page:change', ->
  $('#supplier').on 'change', ->
    this.form.submit()

  $('input[type=checkbox].transfer').on 'click', ->
    $(this).closest('tbody').find('.extra-attributes').toggle()

  $('input[type=checkbox].transfer_master').on 'click', ->
    $('input[type=checkbox].transfer:visible').trigger 'click'

  $('select.category_master').on 'change', ->
    $("select.category:visible").each ->
      selected_val = $("select.category_master option:selected").val()
      $(this).val(selected_val)

  $('select.subcategory_master').on 'change', ->
    $("select.subcategory:visible").each ->
      selected_val = $("select.subcategory_master option:selected").val()
      $(this).val(selected_val)

  $('select.brand_master').on 'change', ->
    $("select.brand:visible").each ->
      selected_val = $("select.brand_master option:selected").val()
      $(this).val(selected_val)

  $('select.dynamic_tree_master').on 'change', ->
    $("select.dynamic_tree:visible").each ->
      selected_val = $("select.dynamic_tree_master option:selected").val()
      $(this).val(selected_val)

  $('input[type=text].visibility_master').on 'keyup', ->
    $('input[type=text].visibility:visible').val($(this).val())

  $('select.status_master').on 'change', ->
    $("select.status:visible").each ->
      selected_val = $("select.status_master option:selected").val()
      $(this).val(selected_val)

  $('input[type=checkbox].purchase_price_master').on 'click', ->
    $('input[type=checkbox].purchase_price:visible').trigger 'click'

  $('input[type=checkbox].supplier_quantity_master').on 'click', ->
    $('input[type=checkbox].supplier_quantity:visible').trigger 'click'
