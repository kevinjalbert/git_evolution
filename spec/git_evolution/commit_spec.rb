require 'spec_helper'

RSpec.describe GitEvolution::Commit do
  describe '.new' do
    let(:raw_commit) { fixture('raw_commit.txt') }

    subject { described_class.new(raw_commit) }

    it 'valid commit parsing' do
      expect(subject.sha).to eq('01da64f8b1021a1007fc3ee9d0acbe87c02217e7')
      expect(subject.author).to eq('Kevin Jalbert <kevin.j.jalbert@gmail.com>')
      expect(subject.date).to eq('Mon Jun 8 07:31:34 2015 -0400')
      expect(subject.subject).to eq("Add ability to acquire the ordered commits for a line range")
      expect(subject.body).to eq("Add spec to test #line_commits. Slight refactoring to make use of\n#line_commits.")
      expect(subject.additions).to eq(5)
      expect(subject.deletions).to eq(0)
    end

    context 'with no body' do
      let(:raw_commit) { fixture('raw_commit_with_no_body.txt') }

      it 'valid commit parsing' do
        expect(subject.sha).to eq('326f5329333e65aebb6ce7f8566d88a58964022a')
        expect(subject.author).to eq('Kevin Jalbert <kevin.j.jalbert@gmail.com>')
        expect(subject.date).to eq('Mon Jun 8 07:47:13 2015 -0400')
        expect(subject.subject).to eq("Add ability to specify the '--since' option for line_{history|commits}")
        expect(subject.body).to eq(nil)
        expect(subject.additions).to eq(4)
        expect(subject.deletions).to eq(2)
      end
    end

    context 'with no diff (i.e., merge commit)' do
      let(:raw_commit) { fixture('raw_commit_with_no_diff.txt') }

      it 'valid commit parsing' do
        expect(subject.sha).to eq('01da64f8b1021a1007fc3ee9d0acbe87c02217e7')
        expect(subject.author).to eq('Kevin Jalbert <kevin.j.jalbert@gmail.com>')
        expect(subject.date).to eq('Mon Jun 8 07:31:34 2015 -0400')
        expect(subject.subject).to eq("Add ability to acquire the ordered commits for a line range")
        expect(subject.body).to eq("Add spec to test #line_commits. Slight refactoring to make use of\n#line_commits.")
        expect(subject.additions).to eq(0)
        expect(subject.deletions).to eq(0)
      end
    end
  end
end
