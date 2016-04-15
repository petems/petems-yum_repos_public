# Fact: java_version
#
# Purpose: get full java version string
#
# Resolution:
#   Tests for presence of java, returns nil if not present
#   returns output of "java -version" and splits on \n + '"'
#
# Caveats:
#   none
#
# Notes:
#   None
Facter.add(:yumrepos_public) do

  public_urls = /public-yum.oracle.com/

  confine :osfamily => %w{RedHat}
  yum_repo_yaml = Facter::Util::Resolution.exec('puppet resource yumrepo -y')
  yum_repo_hash = YAML.load yum_repo_yaml
  list_of_repos = yum_repo_hash['yumrepo']
  if list_of_repos
    public_repos = []
    list_of_repos.each do | yumrepo_array |
      if yumrepo_array[1]['baseurl'].match(public_urls)
        repo = Hash.new
        repo['repo_name'] = yumrepo_array[0]
        repo['baseurl'] = yumrepo_array[1]['baseurl']
        repo['descr'] = yumrepo_array[1]['descr']
        public_repos << repo
      end
    end
  end
  setcode do
    public_repos unless public_repos.empty?
  end
end
