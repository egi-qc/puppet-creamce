if File.exists?("/usr/bin/lsid") 
  Facter.add('batchversion') do
    setcode do
      Facter::Util::Resolution.exec('/usr/bin/lsid 2>/dev/null|grep LSF | awk \'{print $4"."$6}\' | /bin/sed -e \'s/,//g\'')
    end
  end
end
