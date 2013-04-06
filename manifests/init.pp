# /etc/puppet/modules/zookeeper/manafests/init.pp

class zookeeper ($server_id) {

    require zookeeper::params
	
	group { "${zookeeper::params::zookeeper_group}":
		ensure => present,
		gid => "800"
	}

	user { "${zookeeper::params::zookeeper_user}":
		ensure => present,
		comment => "Zookeeper",
		password => "!!",
		uid => "800",
		gid => "800",
		shell => "/bin/bash",
		home => "${zookeeper::params::zookeeper_user_path}",
		require => Group["${zookeeper::params::zookeeper_group}"],
	}
	
    file { "${zookeeper::params::zookeeper_user_path}/.bashrc":
    	ensure => present,
    	owner => "${zookeeper::params::zookeeper_user}",
    	group => "${zookeeper::params::zookeeper_group}",
    	alias => "${zookeeper::params::zookeeper_user}-bashrc",
    	content => template("zookeeper/home/bashrc.erb"),
    	require => [ User["${zookeeper::params::zookeeper_user}"], File["${zookeeper::params::zookeeper_user}-home"] ]
    }
    	
	file { "${zookeeper::params::zookeeper_user_path}":
		ensure => "directory",
		owner => "${zookeeper::params::zookeeper_user}",
		group => "${zookeeper::params::zookeeper_group}",
		alias => "${zookeeper::params::zookeeper_user}-home",
		require => [ User["${zookeeper::params::zookeeper_user}"], Group["${zookeeper::params::zookeeper_group}"] ]
	}
 
	file {"${zookeeper::params::zookeeper_data_path}":
		ensure => "directory",
		owner => "${zookeeper::params::zookeeper_user}",
		group => "${zookeeper::params::zookeeper_group}",
		alias => "zookeeper-data-dir",
		require => File["${zookeeper::params::zookeeper_user}-home"]
	}
 
	file {"${zookeeper::params::zookeeper_base}":
		ensure => "directory",
		owner => "${zookeeper::params::zookeeper_user}",
		group => "${zookeeper::params::zookeeper_group}",
		alias => "zookeeper-base",
	}

 	file {"${zookeeper::params::zookeeper_conf}":
		ensure => "directory",
		owner => "${zookeeper::params::zookeeper_user}",
		group => "${zookeeper::params::zookeeper_group}",
		alias => "zookeeper-conf",
        require => [File["zookeeper-base"], Exec["untar-zookeeper"]],
        before => [ File["zoo-cfg"] ]
	}
 
	file { "${zookeeper::params::zookeeper_base}/zookeeper-${zookeeper::params::version}.tar.gz":
		mode => 0644,
		owner => "${zookeeper::params::zookeeper_user}",
		group => "${zookeeper::params::zookeeper_group}",
		source => "puppet:///modules/zookeeper/zookeeper-${zookeeper::params::version}.tar.gz",
		alias => "zookeeper-source-tgz",
		before => Exec["untar-zookeeper"],
		require => File["zookeeper-base"]
	}
	
	exec { "untar zookeeper-${zookeeper::params::version}.tar.gz":
		command => "tar xfvz zookeeper-${zookeeper::params::version}.tar.gz",
		cwd => "${zookeeper::params::zookeeper_base}",
		creates => "${zookeeper::params::zookeeper_base}/zookeeper-${zookeeper::params::version}",
		alias => "untar-zookeeper",
		refreshonly => true,
		subscribe => File["zookeeper-source-tgz"],
		user => "${zookeeper::params::zookeeper_user}",
		before => [ File["zookeeper-symlink"], File["zookeeper-app-dir"]],
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
	}

	file { "${zookeeper::params::zookeeper_base}/zookeeper-${zookeeper::params::version}":
		ensure => "directory",
		mode => 0644,
		owner => "${zookeeper::params::zookeeper_user}",
		group => "${zookeeper::params::zookeeper_group}",
		alias => "zookeeper-app-dir",
        require => Exec["untar-zookeeper"],
	}
		
	file { "${zookeeper::params::zookeeper_base}/zookeeper":
		force => true,
		ensure => "${zookeeper::params::zookeeper_base}/zookeeper-${zookeeper::params::version}",
		alias => "zookeeper-symlink",
		owner => "${zookeeper::params::zookeeper_user}",
		group => "${zookeeper::params::zookeeper_group}",
		require => File["zookeeper-source-tgz"],
		before => [ File["zoo-cfg"] ]
	}
	
    file { "${zookeeper::params::zookeeper_base}/zookeeper-${zookeeper::params::version}/conf/zoo.cfg":
    	owner => "${zookeeper::params::zookeeper_user}",
    	group => "${zookeeper::params::zookeeper_group}",
    	mode => "644",
    	alias => "zoo-cfg",
        require => File["zookeeper-app-dir"],
    	content => template("zookeeper/conf/zoo.cfg"),
    }

    file { "${zookeeper::params::zookeeper_data_path}/myid":
        owner => "${zookeeper::params::zookeeper_user}",
        group => "${zookeeper::params::zookeeper_group}",
        mode => "644",
        content => $server_id,
        require => File["zookeeper-data-dir"],
        alias => "zookeeper-myid",
    }
    
}
