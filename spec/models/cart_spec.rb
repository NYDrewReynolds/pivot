RSpec.describe Cart, type: :model do
  let(:cart) { Cart.new([1,2,2,3]) }

  it "has an array of item ids" do
    expect(cart.items).to be_a Array
    expect(cart.to_a).to eq(cart.items)
  end

  it "can populate an array of items and quantities" do
    create(:item)
    create(:item, id: 2)
    create(:item, id: 3)

    result = cart.item_ids_to_quantities
    expect(result).to eq([[Item.find(1), 1], [Item.find(2), 2], [Item.find(3), 1]])
  end

  it "can add an item and its quantity to its items" do
    cart.add_item(5, 3)
    expect(cart.items).to eq([1,2,2,3,5,5,5])
  end

  it "can return a size" do
    expect(cart.size).to eq(4)
  end

  it "can delete an item" do
    cart.delete(2)
    expect(cart.items).to eq([1,3])
  end

  it "can update quantity of an item" do
    cart.update_quantity(3, 3)
    expect(cart.items).to eq([1,2,2,3,3,3])
  end

  it "can clear" do
    cart.clear
    expect(cart.items).to be_empty
  end
end
