# /etc/puppet/modules/zookeeper/manafests/init.pp

class zookeeper::params {

	include java::params

	$version = $::hostname ? {
		default			=> "3.4.6",
	}

 	$zookeeper_user = $::hostname ? {
		default			=> "zookeeper",
	}
 
 	$zookeeper_group = $::hostname ? {
		default			=> "hadoop",
	}
        
	$servers = $::hostname ? {
		default			=> ["localhost"] 
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

    $kerberos_mode = $::hostname ? {
        default            => "yes",
    }

    $keytab_path = $::hostname ? {
        default            => "/etc/security/keytab",
    }

    $kerberos_realm = $::hostname ? {
        default            => "OPENSTACKLOCAL",
    }

}
