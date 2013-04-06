# /etc/puppet/modules/zookeeper/manafests/init.pp

class zookeeper::params {

	include java::params

	$version = $::hostname ? {
		default			=> "3.4.5",
	}

 	$zookeeper_user = $::hostname ? {
		default			=> "hduser",
	}
 
 	$zookeeper_group = $::hostname ? {
		default			=> "hadoop",
	}
        
	$servers = $::hostname ? {
		default			=> ["server1", "server2", "server3"] 
	}
 
	$java_home = $::hostname ? {
		default			=> "${java::params::java_base}/jdk${java::params::java_version}",
	}

	$zookeeper_base = $::hostname ? {
		default			=> "/opt/zookeeper",
	}
 
	$zookeeper_conf = $::hostname ? {
		default			=> "${zookeeper_base}/zookeeper/conf",
	}
 
    $zookeeper_user_path = $::hostname ? {
		default			=> "/home/${zookeeper_user}",
	}             

 	$zookeeper_data_path = $::hostname ? {
		default			=> "/var/zookeeper",
	}
}
