module RepositoryHelper
  module_function

  def create_repository
    @tmp_git_dir = Dir.mktmpdir
    @repo = Rugged::Repository.init_at(@tmp_git_dir)
  end

  def delete_repository
    FileUtils.rm_r(@tmp_git_dir)
  end

  def repository_dir
    File.realpath(@tmp_git_dir) + '/'
  end

  def add_to_index(file_name, blob_content)
    object_id = @repo.write(blob_content, :blob)
    @repo.index.add(path: file_name, oid: object_id, mode: 0100644)
  end

  def create_commit(author_name, author_email, time, subject, body = nil)
    author = { email: author_email, name: author_name, time: time }

    tree = @repo.index.write_tree(@repo)

    commit = Rugged::Commit.create(@repo,
                                   author: author,
                                   message: "#{subject}\n\n#{body}".strip,
                                   committer: author,
                                   parents: @repo.empty? ? [] : [@repo.head.target].compact,
                                   tree: tree,
                                   update_ref: 'HEAD')

    @repo.checkout('master', strategy: [:force])

    commit
  end
end
