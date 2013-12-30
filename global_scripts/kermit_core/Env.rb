class Env
  @@os_info ||= nil
  @@os_name ||= nil
  @@os_version ||= nil
  @@os_serial ||= nil
  @@cpu_name ||= nil
  @@cpu_count ||= nil
  @@system_name ||= nil
  @@system_manufacturer ||= nil
  @@system_model ||= nil
  @@system_type ||= nil
  @@mem_total_physical ||= nil
  @@disk_size_total ||= nil
  @@disk_size_avail ||= nil
  @@squish_version ||= nil

  def Env.os_info
    @@os_info = "#{os_name} v#{os_version}"
  end

  def Env.os_name
    if @@os_name.nil?
      result = execute_wmic("wmic os get Name")
      str = result[1]
      @@os_name = str[0..(str.index("|") - 1)]
    end

    @@os_name
  end

  def Env.os_version
    if @@os_version.nil?
      result = execute_wmic("wmic os get Version")
      @@os_version = result[1]
    end

    @@os_version
  end

  def Env.os_serial
    if @@os_serial.nil?
      result = execute_wmic("wmic os get SerialNumber")
      @@os_serial = result[1]
    end

    @@os_serial
  end

  def Env.cpu_name
    if @@cpu_name.nil?
      result = execute_wmic("wmic cpu get name")
      @@cpu_name = result[1]
    end

    @@cpu_name
  end

  def Env.system_name
    if @@system_name.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_name
  end

  def Env.system_manufacturer
    if @@system_manufacturer.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_manufacturer
  end

  def Env.system_model
    if @@system_model.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_model
  end

  def Env.system_type
    if @@system_type.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_type
  end

  def Env.mem_total_physical
    if @@mem_total_physical.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@mem_total_physical
  end

  def Env.disk_size_total
    if @@disk_size_total.nil?
      result = execute_wmic("wmic Logicaldisk where(DeviceID='C:') get size")
      @@disk_size_total = (Float(result[1]) / (2**30)).round(3).to_s + " GB" # in Gigabytes
    end

    @@disk_size_total
  end

  def Env.disk_size_avail
    if @@disk_size_avail.nil?
      result = execute_wmic("wmic Logicaldisk where(DeviceID='C:') get FreeSpace")
      @@disk_size_avail = (Float(result[1]) / (2**30)).round(3).to_s + " GB" # in Gigabytes
    end

    @@disk_size_avail
  end

  def Env.squish_version
    if @@squish_version.nil?
      @@squish_version = Squishinfo.version_str
    end

    @@squish_version
  end


  private

  def self.set_computer_system_vars(system_hash)
    @@system_name = system_hash["Name"]
    @@system_manufacturer = system_hash["Manufacturer"]
    @@system_model = system_hash["Model"]
    @@system_type = system_hash["SystemType"]
    @@mem_total_physical = (Float(system_hash["TotalPhysicalMemory"]) / (2**30)).round(3).to_s + " GB" # in Gigabytes
  end

end