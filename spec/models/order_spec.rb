RSpec.describe Order, :type => :model do
  let(:order) { create(:order) }

  it "is valid when it has items" do
    expect(order).to be_valid
  end

  it "is invalid when it is created without items" do
    order2 = build(:order, items: [])
    expect(order2).to_not be_valid
  end

  it "is invalid without a user" do
    order.user = nil
    expect(order).to_not be_valid
  end

  it "has an exchange of either pickup or delivery" do
    order.exchange = "neither"
    expect(order).to be_invalid
  end

  it 'is invalid without a correct status' do
    order.status = nil
    expect(order).to_not be_valid
    order.status = 'neither'
    expect(order).to_not be_valid
    order.status = 'ready_for_prep'
    expect(order).to be_valid
    order.status = 'cancelled'
    expect(order).to be_valid
  end

  context "when the exchange is a pickup" do
    it 'is valid without a street number' do
      order.street_number = ''
      expect(order).to be_valid
    end

    it 'is valid without a street' do
      order.street = ''
      expect(order).to be_valid
    end

    it 'is valid without a city' do
      order.city = ''
      expect(order).to be_valid
    end

    it 'is valid without a state' do
      order.state = ''
      expect(order).to be_valid
    end

    it 'is valid without a zip' do
      order.zip = ''
      expect(order).to be_valid
    end
  end

  context "when the exchange is a delivery" do
    before do
      order.exchange = 'delivery'
    end

    it 'is invalid without a street number' do
      order.street_number = ''
      expect(order).to_not be_valid
    end

    it 'is invalid without a street' do
      order.street = ''
      expect(order).to_not be_valid
    end

    it 'is invalid without a city' do
      order.city = ''
      expect(order).to_not be_valid
    end

    it 'is invalid without a state' do
      order.state = ''
      expect(order).to_not be_valid
    end

    it 'is invalid without a zip' do
      order.zip = ''
      expect(order).to_not be_valid
    end

    it 'is invalid without a legitimate state' do
      order.state = 'AA'
      expect(order).to_not be_valid
    end

    it "is invalid without a proper zip code" do
      order.zip = 'abc'
      expect(order).to_not be_valid
      order.zip = '1234'
      expect(order).to_not be_valid
    end
  end
end
