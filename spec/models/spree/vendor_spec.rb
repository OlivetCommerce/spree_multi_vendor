require 'spec_helper'

describe Spree::Vendor do
  describe 'associations' do
    it { is_expected.to have_many(:commissions) }
    it { is_expected.to have_many(:option_types) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to have_many(:properties) }
    it { is_expected.to have_many(:shipping_methods) }
    it { is_expected.to have_many(:stock_locations) }
    it { is_expected.to have_many(:variants) }
    it { is_expected.to have_many(:vendor_users) }
    it { is_expected.to have_many(:users).through(:vendor_users) }
    if Spree.version.to_f >= 3.6
      it { is_expected.to have_one(:image) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value('flower').for(:name) }
    it { is_expected.to allow_value('flower455').for(:name) }
    it { is_expected.to allow_value('flower 455').for(:name) }
    it { is_expected.to allow_value('flower abc').for(:name) }
    it { is_expected.to allow_value('flower455 abc').for(:name) }
    it { is_expected.to allow_value('flower 455 abc').for(:name) }
    it { is_expected.not_to allow_value('flower^&%$#').for(:name) }
    it { is_expected.not_to allow_value('flower^&%$# memo').for(:name) }
  end

  describe 'initial state' do
    it 'initial state should be pending' do
      should be_pending
    end
  end

  describe 'after_create' do
    let!(:vendor) { build(:vendor) }

    it 'creates a stock location with default country' do
      expect { vendor.save! }.to change(Spree::StockLocation, :count).by(1)
      stock_location = Spree::StockLocation.last
      expect(vendor.stock_locations.first).to eq stock_location
      expect(stock_location.country).to eq Spree::Country.default
    end

    it 'should act as list' do
      expect(vendor).to respond_to(:set_list_position)
    end
  end
end
