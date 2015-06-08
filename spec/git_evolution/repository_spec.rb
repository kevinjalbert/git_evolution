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

  describe '#commit' do
    context 'valid repository directory' do
      before(:each) do
        create_repository
        add_to_index('README.md', "This is a Reedme\n\TODO stuff")
        commit
      end

      after(:each) { delete_repository }

      let(:commit) { create_commit('John Smith', 'john@smith.com', Chronic.parse('1 day ago'), 'Initial Commit') }

      it 'returns commit' do
        repo = described_class.new(repository_dir)
        repo_commit = repo.commit(commit)

        expect(repo_commit).to be_a(GitEvolution::Commit)
        expect(repo_commit.sha).to eq(commit)
        expect(repo_commit.sha.size).to eq(40)
      end
    end
  end

  describe '#line_history' do
    context 'valid repository directory' do
      before(:each) do
        create_repository

        add_to_index('README.md', "This is a Reedme\n\TODO stuff")
        create_commit('John Smith', 'john@smith.com', Chronic.parse('1 day ago'), commit1_subject)

        add_to_index('README.md', "This is a Readme\n\TODO stuff")
        create_commit('John', 'john@smith.com', Chronic.parse('now'), commit2_subject, 'Fix typo: Reedme -> Readme')
      end
      after(:each) { delete_repository }

      let(:commit1_subject) { 'Initial Commit' }
      let(:commit2_subject) { 'Fix typo in README' }

      it 'returns commit log containing commits' do
        repo = described_class.new(repository_dir)
        line_history = repo.line_history(1, 2, 'README.md')

        expect(line_history).to include(commit1_subject)
        expect(line_history).to include(commit2_subject)
      end
    end
  end
end
