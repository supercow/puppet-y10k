require 'spec_helper'
describe 'y10k' do

  let(:facts) do
    {
      :concat_basedir => '/var/lib/puppet/concat',
      :osfamily       => 'RedHat',
      :path           => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :kernel         => 'Linux',
    }
  end

  context 'with defaults for all parameters' do
    it { should compile.with_all_deps }
    it { should contain_class('y10k') }

    it { should contain_package('y10k')}
  end

  context 'with parameters' do
    config_file = '/tmp/y10k.conf'
    prefix = '/var/yum'

    let(:params) {
      {
        :config_file => config_file,
        :prefix      => prefix,
      }
    }

    it { should contain_concat(config_file).with({
        'ensure' => 'present',
        'name'   => config_file,
      })
    }

    it { should contain_concat__fragment('y10k base config').with({
        'target' => config_file,
      })
    }

    it { should contain_concat__fragment('y10k base config').with_content(/pathprefix=#{prefix}/) }
  end

end
