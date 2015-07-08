module ItemQuantity
  extend ActiveSupport::Concern

  def item_ids_to_quantities
    items.group_by { |id| id }
    .map { |id, ids| [Item.find(id), ids.size] }
  end

  def items_to_quantities
    items.group_by { |item| item }
    .map { |item, items| [item, items.size] }
  end
end
