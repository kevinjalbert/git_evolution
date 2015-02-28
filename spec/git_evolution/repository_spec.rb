require 'spec_helper'

RSpec.describe GitEvolution::Repository do
  describe '.new' do
    context 'valid repository directory' do
      before(:each) { create_repository }
      after(:each) { delete_repository }

      it 'detects repository' do
        repo = described_class.new(repository_dir)
        expect(repo.dir).to eq(repository_dir)
      end
    end

    context 'invalid repository directory' do
      let!(:tmp_dir) { Dir.mktmpdir }
      after { FileUtils.rm_r(tmp_dir) }

      it 'detects no repository' do
        expect { described_class.new(tmp_dir) }.to raise_error(Rugged::RepositoryError)
      end
    end
  end
end
