require 'spec_helper'

RSpec.describe GitEvolution::OptionHandler do
  describe '.parse_options' do
    subject { described_class.parse_options([file]) }

    let!(:tmp_dir) { Dir.mktmpdir }
    let(:file) { tmp_dir + '/file.txt' }
    let(:start_line) { 1 }
    let(:end_line) { 10 }

    before do
      IO.write(file, (1..20).map { ".\n" }.join)
      allow(described_class).to receive(:parse_range) { [start_line, end_line] }
    end

    after { FileUtils.rm_r(tmp_dir) }

    it 'parses options correctly' do
      expect(subject.start_line).to eq(start_line)
      expect(subject.end_line).to eq(end_line)
      expect(subject.file).to eq(file)
    end
  end

  describe '.parse_range' do
    context 'valid range' do
      let(:range) { '10:20' }
      let(:expected_start_line) { 10 }
      let(:expected_end_line) { 20 }

      it 'detects range' do
        start_line, end_line = subject.parse_range(range)
        expect(start_line).to eq(expected_start_line)
        expect(end_line).to eq(expected_end_line)
      end
    end

    context 'invalid range' do
      let(:range) { '10.20' }

      it 'raises exception' do
        expect { described_class.parse_range(range) }.to raise_error
      end
    end
  end

  describe '.validate_options!' do
    let(:options) do
      OpenStruct.new(
        file: file,
        range: range,
        start_line: start_line,
        end_line: end_line
      )
    end

    let!(:tmp_dir) { Dir.mktmpdir }
    let(:file) { tmp_dir + '/file.txt' }
    let(:range) { '1:2' }
    let(:start_line) { 1 }
    let(:end_line) { 20 }

    before { IO.write(file, (1..20).map { ".\n" }.join) }

    after { FileUtils.rm_r(tmp_dir) }

    it 'valid options' do
      expect { described_class.validate_options!(options) }.to_not raise_error
    end

    context 'start_line is larger than end_line' do
      let(:start_line) { 10 }
      let(:end_line) { 1 }

      it 'invalid options' do
        expect { described_class.validate_options!(options) }.to raise_error
      end
    end

    context 'file does not exist' do
      let(:file) { tmp_dir + '/not_here.txt' }

      before { FileUtils.rm(file) }

      it 'invalid options' do
        expect { described_class.validate_options!(options) }.to raise_error
      end

      context 'missing file argument' do
        it 'invalid options' do
          options.file = nil
          expect { described_class.validate_options!(options) }.to raise_error
        end
      end
    end

    context 'end_line is larger than file length' do
      let(:start_line) { 10 }
      let(:end_line) { 40 }

      it 'invalid options' do
        expect { described_class.validate_options!(options) }.to raise_error
      end
    end
  end
end
