module RepositoryHelper
  module_function

  def create_repository
    @tmp_git_dir = Dir.mktmpdir
    Rugged::Repository.init_at(@tmp_git_dir)
  end

  def delete_repository
    FileUtils.rm_r(@tmp_git_dir)
  end

  def repository_dir
    File.realpath(@tmp_git_dir) + '/'
  end
end
