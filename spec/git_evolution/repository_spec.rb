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

  describe '#line_commits' do
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

      it 'returns commits for the specifed line range' do
        repo = described_class.new(repository_dir)
        line_commits = repo.line_commits(1, 2, 'README.md')

        expect(line_commits.size).to eq(2)
        expect(line_commits.first).to be_a(GitEvolution::Commit)
        expect(line_commits.first.subject).to eq(commit2_subject)
        expect(line_commits.last.subject).to eq(commit1_subject)
      end
    end
  end

  describe '#raw_line_history' do
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

      it 'returns raw commit log containing commits' do
        repo = described_class.new(repository_dir)
        raw_line_history = repo.raw_line_history(1, 2, 'README.md')

        expect(raw_line_history).to include(commit1_subject)
        expect(raw_line_history).to include(commit2_subject)
      end

      context 'with since option' do
        it 'returns only commit within last 6 hours' do
          repo = described_class.new(repository_dir)
          raw_line_history = repo.raw_line_history(1, 2, 'README.md', '6 hours ago')

          expect(raw_line_history).to_not include(commit1_subject)
          expect(raw_line_history).to include(commit2_subject)
        end
      end
    end
  end
end
