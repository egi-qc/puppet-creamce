if File.exists?("/usr/sbin/update-alternatives") 
  Facter.add('javaversion') do
    setcode do
      Facter::Util::Resolution.exec('/usr/sbin/update-alternatives --display java|grep \'link currently points to\' |awk \'{print $5}\'')
    end
  end
end
