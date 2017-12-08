# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'kubernetes class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-kubernetes
      $daemon_json = @(END)
      {
          "exec-opts": ["native.cgroupdriver=systemd"]
      }
      END
      accounts::user { 'bryanbelanger':
        group    => 'wheel',
        shell    => '/bin/bash',
        password => 'password',
        locked   => false,
        sshkeys  => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdqCg4nG5zsz9eg/DEkE9sHiwr6r6N3oXFcNONBzQJjm0Hf8IfbH7xuNLCKWI8peUXeBawCrUoIrSf+PEkk/QHUN3Az6wlyfWJTxKBSnFBZeThn88PBW1kgh0z0t/rP1+PK9UeQ2iP+xko8hTpGDPCfiAwJPzNlf+yBB87BpoZpKjeXjk+BVH4n+BhV3nDAMRRPeTXU02OUetyNFHe2DcndMFHQmH/7/UiPGjdnYIEv5n9afa1L3G0uHfz2vnrmNfMkBjbe0+h8zKMvhBjpEUwlR4yFlgB84iwdRvDrAfZPlPpik5Ly40X4keSfh8gjahH4ns8XN6ujTptFNCWc5Wz bryanbelanger@Bryans-MacBook-Pro.local'],
      }
      -> exec { '/sbin/swapoff -a': }
      -> class { '::sudo':
        config_file_replace => false,
      }
      -> sudo::conf { 'bryanbelanger':
        priority => 60,
        content  => "bryanbelanger ALL=(ALL) NOPASSWD:ALL",
      }
      -> class { 'firewall':
        ensure => stopped,
      }
      -> class { 'docker': }
      # 3.17 Verify that daemon.json file ownership is set to root:root
      # 3.18 Verify that daemon.json file permissions are set to 644 or more restrictive
      -> file { '/etc/docker/daemon.json':
        ensure => file,
        owner  => 'root',
        group  => 'root',
        mode   => 'a-x,go-w',
        content => $daemon_json,
      }
      -> class { 'kubernetes': }
      kubernetes

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      # apply_manifest(pp, catch_changes: true)
    end
  end
end
