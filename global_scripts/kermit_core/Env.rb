########################################################################################
#
#  Test execution environment
#     Used to store the execution environment
#
#  @author  Matt Siwiec
#
########################################################################################

# Executes the given wmic command and returns the result hash
# Params: command_str - wmic command string
def execute_wmic(command_str)
  pipe = IO.popen(command_str)

  # returns a string of information with a bunch of spaces and newlines
  result = pipe.readlines

  # Close the process pipe
  pipe.close
  pipe = nil

  # Santize all the extra junk returned
  result.delete("\n")
  result.each do |x|
    x.gsub!(/[ \n]/, "")
  end


  # turn this array of key-value string pairs into a hash, if the wmic command
  # is returning the full list of values from the query
  if command_str.include?("list full")
    hash = Hash.new
    result.each_with_index do |x|
      kv_array = x.split('=')
      hash[kv_array[0]] = kv_array[1]
    end

    return hash
  end

  return result
end

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
  @@hard_coded_squish_default_version = "5.0.0" # for when we need to generate an HTML log manually. Update as needed
  @@squish_version ||= nil

  # Operating System name and version
  def Env.os_info
    @@os_info = "#{os_name} v#{os_version}"
  end

  # Query operating system name from wmic
  def Env.os_name
    if @@os_name.nil?
      result = execute_wmic("wmic os get Name")
      str = result[1]
      @@os_name = str[0..(str.index("|") - 1)]
    end

    @@os_name
  end

  # Query operating system version from wmic
  def Env.os_version
    if @@os_version.nil?
      result = execute_wmic("wmic os get Version")
      @@os_version = result[1]
    end

    @@os_version
  end

  # Query operating system serial number from wmic
  def Env.os_serial
    if @@os_serial.nil?
      result = execute_wmic("wmic os get SerialNumber")
      @@os_serial = result[1]
    end

    @@os_serial
  end

  # Query cpu name from wmic
  def Env.cpu_name
    if @@cpu_name.nil?
      result = execute_wmic("wmic cpu get name")
      @@cpu_name = result[1]
    end

    @@cpu_name
  end

  # Query computer system name from wmic
  def Env.system_name
    if @@system_name.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_name
  end

  # Query system manufacturer name from wmic
  def Env.system_manufacturer
    if @@system_manufacturer.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_manufacturer
  end

  # Query system model string name from wmic
  def Env.system_model
    if @@system_model.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_model
  end

  # Query operating system type from wmic
  def Env.system_type
    if @@system_type.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@system_type
  end

  # Query system total physical memory from wmic
  def Env.mem_total_physical
    if @@mem_total_physical.nil?
      set_computer_system_vars(execute_wmic("wmic computersystem list full"))
    end

    @@mem_total_physical
  end

  # Query system disk total size from wmic
  def Env.disk_size_total
    if @@disk_size_total.nil?
      result = execute_wmic("wmic Logicaldisk where(DeviceID='C:') get size")
      @@disk_size_total = (Float(result[1]) / (2**30)).round(3).to_s + " GB" # in Gigabytes
    end

    @@disk_size_total
  end

  # Query system disk available size from wmic
  def Env.disk_size_avail
    if @@disk_size_avail.nil?
      result = execute_wmic("wmic Logicaldisk where(DeviceID='C:') get FreeSpace")
      @@disk_size_avail = (Float(result[1]) / (2**30)).round(3).to_s + " GB" # in Gigabytes
    end

    @@disk_size_avail
  end

  # Query squish version from Squish library
  def Env.squish_version
    if @@squish_version.nil?
      if defined?("Squishinfo") == "constant"
        @@squish_version = Squishinfo.version_str
      else
        @@squish_version = @@hard_coded_squish_default_version
      end
    end

    @@squish_version
  end


  private

  # set the static variables from system_hash passed in
  def self.set_computer_system_vars(system_hash)
    @@system_name = system_hash["Name"]
    @@system_manufacturer = system_hash["Manufacturer"]
    @@system_model = system_hash["Model"]
    @@system_type = system_hash["SystemType"]
    @@mem_total_physical = (Float(system_hash["TotalPhysicalMemory"]) / (2**30)).round(3).to_s + " GB" # in Gigabytes
  end

end