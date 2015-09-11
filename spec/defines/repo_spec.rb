require 'spec_helper'
describe 'y10k::repo', :type => :define do

  let(:facts) do
    {
      :concat_basedir => '/var/lib/puppet/concat',
      :osfamily       => 'RedHat',
      :path           => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :kernel         => 'Linux',
    }
  end

  name = 'my_repo'
  arch = 'x86_64'
  interval = {
    'weekday' => 7,
    'hour'    => 4,
    'minute'  => 0,
  }
  #mirrorlist = 'https://example.com/?mirrors'
  mirrorlist = 'http://example.com/mirrors'
  localpath = "centos/7/#{arch}/#{name}"

  params = {
    :mirrorlist    => mirrorlist,
    :localpath     => localpath,
    :arch          => arch,
    :deleteremoved => true,
    :interval      => interval,
  }


  let(:title) { name }
  let(:params) { params }

  config_file = '/etc/y10k.conf'
  let(:pre_condition) { <<-EOF
    class { 'y10k':
      config_file => '#{config_file}',
    }
    EOF
  }

  context 'with basic parameters' do
    it { should compile.with_all_deps }
    it { should contain_cron("#{name} repo sync").with(interval) }

    it { should contain_concat__fragment("y10k repo #{name}").with({:target => config_file})}

    it { should contain_concat__fragment("y10k repo #{name}").with_content(/\[#{name}\]/)}
    non_template_params = [:deleteremoved,:interval]
    params.each_pair do |k,v|
      next if non_template_params.include?(k)
      it { should contain_concat__fragment("y10k repo #{name}").with_content(
        /#{k.to_s}=#{v}/
      )}
    end
  end

  context 'with mirrorlist and baseurl unset' do
    let(:params) { params.merge({ :mirrorlist => 'UNSET', :baseurl => 'UNSET' }) }
    it { should raise_error(Puppet::Error) }
  end

end
