product_row = $('<%= "#pending_updates_#{@product.id}" %>')

<% if @product.errors.present? %>
message = "<font class='error'><%= @product.errors.full_messages.join('<br>') %></font><br><br>"
<% else %>
message = "<font class='ok'><%= t('.update_success') %></font><br><br>"

nested_fields = product_row.find('div.nested-fields')
count = nested_fields.length

nested_fields.find('input:checkbox:checked').each (index, element) =>
  $(element).parent().remove()
  count--

if count == 0
  product_row.siblings('input.submit').hide()
  message = ""

<% end %>

$('#pending_update_container_<%= @product.id %>').html('<%= j render 'form', product: @product %>');

product_row = $('<%= "#pending_updates_#{@product.id}" %>')

product_row.find('div.notifications').html(message)

$('.key-select').trigger('change')
