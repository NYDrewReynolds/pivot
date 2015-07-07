RSpec.describe Item, :type => :model do
  let(:item) { create(:item) }

  it 'is valid' do
  	expect(item).to be_valid
  end

  it 'is invalid without a title' do
  	item.title = nil
  	expect(item).to_not be_valid
  end

  it 'is invalid without a description' do
  	item.description = nil
  	expect(item).to_not be_valid
  end

  it 'is invalid if price is equal to zero' do
  	item.price = 0.00
  	expect(item).to_not be_valid
  end

  it 'is invalid if price is less than zero' do
  	item.price = -5
  	expect(item).to_not be_valid
  end

  it 'is invalid if price is not numeric' do
  	item.price = "asdf"
  	expect(item).to_not be_valid
  end

  it 'is invalid without category' do
    item.categories = []
    expect(item).to_not be_valid
  end

  it "knows if it is vegetarian" do
    expect(item.vegetarian?).to be false
  end
end
