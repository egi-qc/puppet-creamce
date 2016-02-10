if File.exists?("/etc/grid-security/hostcert.pem") 
  Facter.add('certsubject') do
    setcode do
      Facter::Util::Resolution.exec('/usr/bin/openssl x509 -in /etc/grid-security/hostcert.pem -noout -subject -nameopt RFC2253| /bin/grep subject | /bin/cut -d= -f 2-20')
    end
  end
end
