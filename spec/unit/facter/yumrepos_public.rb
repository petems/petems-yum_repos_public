require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe 'yum_repos_public' do
    context 'returns package versions when rpm present' do
      before do
        Facter.fact(:osfamily).stubs(:value).returns("RedHat")
        Facter.fact(:operatingsystem).stubs(:value).returns("RedHat")
        Facter::Util::Resolution.stubs(:exec)
      end
      let(:facts) { {:operatingsystem => 'RedHat'} }
      it do
        yum_repos_puppet_yaml = <<-EOS
yumrepo:
  ol7_MySQL55:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/MySQL55/$basearch/'
    descr   : 'MySQL 5.5 for Oracle Linux 7 ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_MySQL56:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/MySQL56/$basearch/'
    descr   : 'MySQL 5.6 for Oracle Linux 7 ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_UEKR3:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/UEKR3/$basearch/'
    descr   : 'Latest Unbreakable Enterprise Kernel Release 3 for Oracle Linux $releasever ($basearch)'
    enabled : '1'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_UEKR3_OFED20:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/UEKR3_OFED20/$basearch/'
    descr   : 'OFED supporting tool packages for Unbreakable Enterprise Kernel on Oracle Linux 7 ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    priority: '20'

  ol7_addons:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/addons/$basearch/'
    descr   : 'Oracle Linux $releasever Add ons ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_latest:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/latest/$basearch/'
    descr   : 'Oracle Linux $releasever Latest ($basearch)'
    enabled : '1'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_optional_latest:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/optional/latest/$basearch/'
    descr   : 'Oracle Linux $releasever Optional Latest ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_spacewalk22_client:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/spacewalk22/client/$basearch/'
    descr   : 'Spacewalk Client 2.2 for Oracle Linux 7 ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_u0_base:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/0/base/$basearch/'
    descr   : 'Oracle Linux $releasever GA installation media copy ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  ol7_u1_base:
    ensure  : 'present'
    baseurl : 'http://public-yum.oracle.com/repo/OracleLinux/OL7/1/base/$basearch/'
    descr   : 'Oracle Linux $releasever Update 1 installation media copy ($basearch)'
    enabled : '0'
    gpgcheck: '1'
    gpgkey  : 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'

  pe_repo:
    ensure   : 'present'
    baseurl  : 'https://mycoolcorporate_mirror.example.com:8140/packages/2016.1.1/el-7-x86_64'
    descr    : 'Puppet Labs PE Packages $releasever - $basearch'
    enabled  : '1'
    gpgcheck : '1'
    gpgkey   : 'https://mycoolcorporate_mirror.example.com:8140/packages/GPG-KEY-puppetlabs'
    proxy    : '_none_'
    sslverify: 'False'
        EOS
        Facter::Util::Resolution.expects(:exec).with('puppet resource yumrepo -y').returns(yum_repos_puppet_yaml)
        expect(Facter.value(:yumrepos_public)).to eq([
          {"repo_name"=>"ol7_MySQL55", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/MySQL55/$basearch/", "descr"=>"MySQL 5.5 for Oracle Linux 7 ($basearch)"},
          {"repo_name"=>"ol7_MySQL56", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/MySQL56/$basearch/", "descr"=>"MySQL 5.6 for Oracle Linux 7 ($basearch)"},
          {"repo_name"=>"ol7_UEKR3", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/UEKR3/$basearch/", "descr"=>"Latest Unbreakable Enterprise Kernel Release 3 for Oracle Linux $releasever ($basearch)"},
          {"repo_name"=>"ol7_UEKR3_OFED20", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/UEKR3_OFED20/$basearch/", "descr"=>"OFED supporting tool packages for Unbreakable Enterprise Kernel on Oracle Linux 7 ($basearch)"},
          {"repo_name"=>"ol7_addons", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/addons/$basearch/", "descr"=>"Oracle Linux $releasever Add ons ($basearch)"},
          {"repo_name"=>"ol7_latest", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/latest/$basearch/", "descr"=>"Oracle Linux $releasever Latest ($basearch)"},
          {"repo_name"=>"ol7_optional_latest", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/optional/latest/$basearch/", "descr"=>"Oracle Linux $releasever Optional Latest ($basearch)"},
          {"repo_name"=>"ol7_spacewalk22_client", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/spacewalk22/client/$basearch/", "descr"=>"Spacewalk Client 2.2 for Oracle Linux 7 ($basearch)"},
          {"repo_name"=>"ol7_u0_base", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/0/base/$basearch/", "descr"=>"Oracle Linux $releasever GA installation media copy ($basearch)"},
          {"repo_name"=>"ol7_u1_base", "baseurl"=>"http://public-yum.oracle.com/repo/OracleLinux/OL7/1/base/$basearch/", "descr"=>"Oracle Linux $releasever Update 1 installation media copy ($basearch)"}
        ])
      end
    end

    context 'returns package versions when rpm present' do
      before do
        Facter.fact(:osfamily).stubs(:value).returns("RedHat")
        Facter.fact(:operatingsystem).stubs(:value).returns("RedHat")
        Facter::Util::Resolution.stubs(:exec)
      end
      let(:facts) { {:operatingsystem => 'RedHat'} }
      it do
        yum_repos_puppet_yaml = <<-EOS
yumrepo:
        EOS
        Facter::Util::Resolution.expects(:exec).with('puppet resource yumrepo -y').returns(yum_repos_puppet_yaml)
        expect(Facter.value(:yumrepos_public)).to eq(nil)
      end
    end

  end
end
