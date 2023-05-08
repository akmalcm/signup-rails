require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:password) }

    context "name" do
      context "minimum 2 chars" do
        subject { build(:user, name: 'a') }

        it 'return errors' do
          expect(subject.valid?).to be_falsey
          expect(subject.errors[:name].first).to eq("is too short (minimum is 2 characters)")
        end
      end
    end

    context "email" do
      context "unique" do
        let!(:user)  { create(:user, email: 'a@test.com') }
        subject { build(:user, email: 'a@test.com') }

        it 'return errors' do
          expect(subject.valid?).to be_falsey
          expect(subject.errors[:email].first).to eq("has already been taken")
        end
      end

      context "pattern" do
        subject { build(:user, email: 'a.com') }

        it 'return errors' do
          expect(subject.valid?).to be_falsey
          expect(subject.errors[:email].first).to eq("is invalid")
        end
      end
    end

    context "phone" do
      context "pattern" do
        subject { build(:user, phone: '011123') }

        it 'return errors' do
          expect(subject.valid?).to be_falsey
          expect(subject.errors[:phone].first).to eq("is invalid")
        end
      end
    end

    context "password" do
      context "minimum length is 5" do
        subject { build(:user, password: 'aaaa') }

        it 'return errors' do
          expect(subject.valid?).to be_falsey
          expect(subject.errors[:password].first).to eq("is too short (minimum is 5 characters)")
        end
      end
    end
  end
end
