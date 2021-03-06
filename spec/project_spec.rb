require 'spec_helper'

describe 'PassMan Project' do
  context 'when checking the gem version' do
    let(:version) { Passman::VERSION }

    it 'is the correct version' do
      expect(version).to eq('0.2.0')
    end
  end
end
