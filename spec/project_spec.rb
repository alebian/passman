require 'spec_helper'

describe 'PassMan Project' do
  context 'when checking the gem version' do
    let(:version) { Passman::VERSION }

    it 'is the correct version' do
      expect(version).to eq('0.0.3')
    end
  end
end
