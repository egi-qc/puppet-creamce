Facter.add('usemaui') do
  setcode do

    if File.exists?("/var/spool/maui/maui.cfg")
      true
    else
      false
    end
    
  end
end
