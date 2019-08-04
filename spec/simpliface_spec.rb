# frozen_string_literal: true

RSpec.describe Simpliface do
  shared_examples 'basic specs' do
    it 'cannot create instance directly' do
      expect do
        test_service.new
      end.to raise_error(NoMethodError, /private method `new'/)
    end

    it 'raises error when called with positional argument' do
      expect do
        test_service.call('some arg')
      end.to raise_error(ArgumentError, /Positional arguments not permitted/)
    end

    it 'raises error when called with unexpected keyword argument' do
      expect do
        test_service.call(arg3: 'val3')
      end.to raise_error(ArgumentError, /Unexpected keyword argument \[:arg3\]/)
    end
  end

  context 'simple service - no arguments' do
    let(:test_service) do
      Class.new do
        include Simpliface

        def call
          'a test string'
        end
      end
    end

    it 'works with no arguments' do
      expect(test_service.call).to eq('a test string')
    end

    it_behaves_like 'basic specs'
  end

  context ' service with arguments' do
    let(:test_service) do
      Class.new do
        include Simpliface

        arguments :arg1, arg2: 'slice'

        def call
          (arg1 + arg2).upcase
        end
      end
    end

    it_behaves_like 'basic specs'

    it 'raises error when called without mandatory keyword argument' do
      expect do
        test_service.call
      end.to raise_error(ArgumentError, /Missing keyword argument \[:arg1\]/)
    end

    it 'works with mandatory argument' do
      expect(test_service.call(arg1: 'dancer')).to eq('DANCERSLICE')
    end

    it 'pass in optional argument' do
      expect(test_service.call(arg1: 'run', arg2: 'basil')).to eq('RUNBASIL')
    end
  end
end
