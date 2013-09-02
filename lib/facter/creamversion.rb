if File.exists?("/etc/glite-ce-cream") 
  Facter.add('creamversion') do
    setcode do
      Facter::Util::Resolution.exec('/bin/rpm -q glite-ce-cream| /bin/cut -d\- -f4')
    end
  end
end
