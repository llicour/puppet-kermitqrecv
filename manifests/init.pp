class kermitqrecv {

    include yum
    include yum::kermit
    include kermit

    package { 'kermit-mqrecv' :
        ensure   => present,
        require  => Yumrepo[ 'kermit-custom', 'kermit-thirdpart' ],
    }

    file { '/etc/kermit/ssl/q-public.pem' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermitqrecv/q-public.pem',
        require => [ File['/etc/kermit/ssl/'], Package['mcollective-common'] ],
    }

    file { '/var/lib/kermit' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/var/lib/kermit/queue' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => [ File['/var/lib/kermit'] ],
    }

    file { 'kermit_inventory' :
        ensure  => directory,
        path    => '/var/lib/kermit/queue/kermit.inventory',
        owner   => 'nobody',
        group   => 'root',
        mode    => '0755',
        require => [ File['/var/lib/kermit/queue'] ],
    }

    file { 'kermit_log' :
        ensure  => directory,
        path    => '/var/lib/kermit/queue/kermit.log',
        owner   => 'nobody',
        group   => 'root',
        mode    => '0755',
        require => [ File['/var/lib/kermit/queue'] ],
    }

    service { 'kermit-inventory' :
        ensure  => running,
        enable  => true,
        require => [ Package['kermit-mqrecv'], File['kermit_inventory'], ],
    }

    service { 'kermit-log' :
        ensure  => running,
        enable  => true,
        require => [ Package['kermit-mqrecv'], File['kermit_log'], ],
    }
}
